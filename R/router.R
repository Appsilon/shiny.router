ROUTER_UI_ID <- '_router_ui'
INPUT_BINDING_ID <- 'shiny_router_inputId'

.onLoad <- function(libname, pkgname) {
  # Adds inst/www directory for loading static resources from server.
  # We need to add that to get all javascript code from client app.
  shiny::addResourcePath('shiny.router.page', system.file('www/bower_components/page/', package = 'shiny.router', mustWork = TRUE))
  shiny::addResourcePath('shiny.router', system.file('www', package = 'shiny.router', mustWork = TRUE))
}

#' Internal function that escapes routing path from not safe characters.
#'
#' @param path A path.
#' @return String with escaped characters.
escape_path <- function(path) {
  clean_path <- gsub("'", "%27", path, fixed = T)
  clean_path <- gsub("\\", "%5C", path, fixed = T)
  clean_path
}

#' Internal function that validates that path is defined in routes.
#'
#' @param routes A routes (list).
#' @param path A path.
#' @return Boolean value indicating if path is defined.
valid_path <- function(routes, path) {
  (!is.null(path) && path %in% names(routes))
}

#' Create single route configuration.
#'
#' @param path Website route.
#' @param ui Valid Shiny user interface.
#' @return A route configuration.
#' @examples
#' route("/", shiny::tags$div(shiny::tags$span("Hello world")))
#'
#' route("/main", div(h1("Main page"), p("Lorem ipsum.")))
#' @export
route <- function(path, ui) {
  out <- list()
  out[[path]] <- ui
  out
}

#' Internal function creating a router callback function.
#' One need to call router callback with Shiny input and output in server code.
#'
#' @param root Main route to which all invalid routes should redirect.
#' @param routes A routes (list).
#' @return Router callback.
create_router_callback <- function(root, routes) {
  function(input, output, session = shiny::getDefaultReactiveDomain()) {

    # # When the user is first visiting the page, check if they entered a URL
    # # with a hashbang path, and if so, take them there.
    # starting_hash <- isolate(session$clientData$url_hash)
    # if (nzchar(starting_hash)) {
    #   # TODO: Can probably shorten this with regexes.
    #   if (substr(starting_hash, 1, 1) == "#") {
    #     starting_hash <- substr(starting_hash, 2, nchar(starting_hash))
    #   }
    #   if (substr(starting_hash, 1, 1) == "!") {
    #     starting_hash <- substr(starting_hash, 2, nchar(starting_hash))
    #   }
    #   parsed_start_url <- httr::parse_url(starting_hash)
    #   startpage <- paste0("/", parsed_start_url)
    #   startpage_with_params <- paste0("/", starting_hash)
    #   cat(file=stderr(), "router startup: found a hash\n")
    # } else {
      cat(file=stderr(), "router startup: found no hash\n")
      # No hashbang path on starting page. Just take them to "/" route then.
      startpage <- "/"
      startpage_with_params <- "/"
    # }
    # cat(file=stderr(), "page: ", startpage, "\npage_with_params: ", startpage_with_params, "\n")

    current_page <- shiny::reactiveVal(list(
      page = startpage,
      page_with_params = startpage_with_params
    ))

    # Watch for updates from page.js to our client-side reactive input,
    # which will tell us when page.js's notion of the current "page" has changed.
    observe({
      cat(file=stderr(), "Inside the observer\n")
      # Creates a reactive dependency on our reactive input.
      location <- get_page()
      cat(file=stderr(), "Location = ", location, "\n")

      if (valid_path(routes, location)) {
        cat(file=stderr(), "It's recognized as valid.\n")
        # If it's a recognized path, then update the display to match.
        current_page(list(
          page = location,
          page_with_params = get_page_with_params()
        ))
        shiny::isolate(cat(
          file=stderr(),
          "Updated current_page.\n",
          "current_page()$page_with_params: ", current_page()$page_with_params, "\n",
          "current_page()$page: ", current_page()$page, "\n"
        ))

        #' TODO: Validation of routes that have mandatory params...
      } else {
        cat(file=stderr(), "Invalid path sent to observer\n")

        # If it's not a recognized path, then don't update the display.
        # Instead, tell page.js to flop the URL back to what it last was.
        shiny::isolate({
          # Doing this in an isolate() block, because we also update the
          # reactive variable "current_page" in this context. Reading
          # current_page() outside of an isolate block would create a reactive
          # dependency on it for this observe() block, and since we also
          # write to current_page() in this block, it would risk creating
          # an infinite loop.
          cat(
            file=stderr(),
            "Sending proper path back up to page.js\n",
            "current_page()$page_with_params: ", current_page()$page_with_params, "\n"
            # "session$clientData$url_hash: ", session$clientData$url_hash, "\n"
          )
          change_page(current_page()$page_with_params)
        })
      }
    })

    # Once the (validated) route has changed, update the UI accordingly.
    output[[ROUTER_UI_ID]] <- shiny::renderUI({
      cat(file=stderr(), "shiny.router main output. page: ", current_page()$page, "\n")
      routes[[current_page()$page]]
    })

    output$shiny.router.status = renderText(
      paste0(
        "get_page(): ", get_page(), "\n",
        "get_page_with_params(): ", get_page_with_params(), "\n",
        "current_page()$page: ", current_page()$page, "\n",
        "current_page()$page_with_params: ", current_page()$page_with_params, "\n"
      )
    )
  }
}

#' Creates router. Returned callback needs to be called within Shiny server code.
#'
#' @param default Main route to which all invalid routes should redirect.
#' @param ... All other routes defined with shiny.router::route function.
#' @return Shiny router callback that should be run in server code with Shiny input and output lists.
#' @examples
#' router <- make_router(
#'   route("/", root_page),
#'   route("/other", other_page)
#' )
#' @export
make_router <- function(default, ...) {
  routes <- c(default, ...)
  root <- names(default)[1]
  create_router_callback(root, routes)
}

#' Creates an output for router. This configures client side.
#' Call it in your UI Shiny code. In this output ui is going to be rendered
#' according to current routing.
#'
#' @return Shiny tags that configure router and build reactive but hidden input _location.
#' @examples
#' ui <- shinyUI(fluidPage(
#'   router_ui()
#' ))
#' @export
router_ui <- function() {
  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src = "shiny.router.page/page.js"),
        shiny::tags$script(src = "shiny.router/shiny.router.js")
      )
    ),
    shiny::tags$input(id = INPUT_BINDING_ID, type = "hidden", value="/"),
    #' TODO debug code
    verbatimTextOutput("shiny.router.status"),
    shiny::uiOutput(ROUTER_UI_ID)
  )
}

#' Convenience function to retrieve one of the fields from the object returned
#' by our client-side reactive input binding. See "shiny.router.js" for the
#' side that writes these.
#'
#' Currently it sends across two fields (which are derived from the page.js
#' "Context" object for the current page.js route being displayed.)
#'
#' page: The "path" part of the URL, with a leading slash. But note that currently
#' we're using hashbanged URLs, e.g. "http://www.example.com/#!path?params=1"
#'
#' page_with_params: The "path" and "query" part of the URL, combined.
#'
#' @param fieldName The field to retrieve
#' @param session The Shiny session.
#' @return The requested field, as a length-1 character vector, or FALSE if the input
#' currently has no value.
#' @reactivesource
get_router_field<- function(field_name, session = shiny::getDefaultReactiveDomain()) {
  # TODO: validation of the field name?
  if (shiny::isTruthy(session$input[[INPUT_BINDING_ID]])) {
    return(session$input[[INPUT_BINDING_ID]][[field_name]] )
  } else {
    return(FALSE)
  }
}

#' Convenience function to retrieve just the "page" part of the input. This
#' corresponds to what might be called the "path" component of a URL, except
#' that we're using URLs with hashes before the path & query (e.g.:
#' http://www.example.com/#!virtual/path?and=params)
#' @param session The current Shiny Session
#' @return The current page in a length-1 character vector, or FALSE if the input
#' has no value.
#' @reactivesource
#' @export
get_page <- function(session = shiny::getDefaultReactiveDomain()) {
  get_router_field("page", session)
}

#' Convenience function to retrieve the full "page and params" part of the input.
#' This corresponds to the path with the query (if any), and is suitable for
#' usage with change_page()
#' @param session The current Shiny session
#' @return The page and params in a length-1 character vector, or FALSE if the
#' input has no value.
#' @reactivesource
#' @export
get_page_with_params <- function(session = shiny::getDefaultReactiveDomain()) {
  get_router_field("page_with_params", session)
}

#' Convenience function to retrieve any params that were part of the requested
#' page. The param values returned come from "httr::parse_url()"
#' @param field If provided, retrieve only a param with this name. (Otherwise,
#' return all params)
#' @param session The Shiny session
#' @return The full list of params on the URL (if any), as a list. Or, the single
#' requested param (if present). Or FALSE if there's no input, or no params.
#' @reactivesource
#' @export
get_page_params <- function(field = NULL, session = shiny::getDefaultReactiveDomain()) {
  cat(file=stderr(), "Trying to fetch field '", field, "'.\n")
  n <- get_router_field("page_with_params", session)
  if(!identical(FALSE, n)) {
    cat(file=stderr(), "page_with_params: '", n, "'\n")
    if (missing(field)) {
      return(
        # Return a list of all the query params
        httr::parse_url(n)$query
      )
    } else {
      fieldVal <- httr::parse_url(n)$query[[field]]
      cat(file = stderr(), "field value: '", fieldVal, "'\n");
      return(fieldVal)
    }
  } else {
    cat(file=stderr(), "Couldn't fetch page_with_params.\n");
    return(FALSE)
  }
}

#' Tell the reactive chain to halt if we're not on the specified page. Useful
#' for making sure we don't waste cycles re-rendering the UI for pages that are
#' not currently displayed.
#' @param page The page to display. Should match one of the paths sent to the
#' @param session Shiny session
#' @param ... Other parameters are sent through to shiny::req()
#' router.
#' @export
#' @reactivesource
is_page <- function(page, session = shiny::getDefaultReactiveDomain(), ...) {
  cat(file=stderr(), "Checking if page is '", page, "'\n");
  get_page(session) == page
}

#' Change the currently displayed page. Works by sending a message up to
#' our reactive input binding on the clientside, which tells page.js to update
#' the window URL accordingly, then tells clientside shiny that our reactive
#' input binding has changed, then that comes back down to our router callback
#' function and all other observers watching get_page() or similar.
#' @param page The new URL to go to. Should just be the path component of the
#' URL, with optional query, e.g. "/learner?id=%d"
#' @param session The current Shiny session.
#' @export
change_page <- function(page, session = shiny::getDefaultReactiveDomain()) {
  cat(file=stderr(), "Sending page change message to client: ", page, "\n")
  session$sendInputMessage(INPUT_BINDING_ID, page)
}
