ROUTER_UI_ID <- '_router_ui'

#' Create a mapping bewtween a ui element
#' and a server callack
#'
#' @param ui Valid Shiny user interface.
#' @param server Function that is called within the global server function if given
callback_mapping <- function(ui, server = NA) {
  server <- if (is.function(server)) {
              server
            } else {
              function(input, output, session, ...) {}
            }
  out <- list()
  out[["ui"]] <- ui
  out[["server"]] <- server
  out
}

#' Create single route configuration.
#'
#' @param path Website route.
#' @param ui Valid Shiny user interface.
#' @param server Function that is called as callback on server side
#' @return A route configuration.
#' @examples
#' \dontrun{
#' route("/", shiny::tags$div(shiny::tags$span("Hello world")))
#'
#' route("/main", div(h1("Main page"), p("Lorem ipsum.")))
#' }
#' @export
route <- function(path, ui, server = NA) {
  out <- list()
  out[[path]] <- callback_mapping(ui, server)
  out
}

#' Internal function creating a router callback function.
#' One need to call router callback with Shiny input and output in server code.
#'
#' @param root Main route to which all invalid routes should redirect.
#' @param routes A routes (list).
#'
#' @importFrom shiny observeEvent
#'
#' @return Router callback.
create_router_callback <- function(root, routes) {
  function(input, output, session = shiny::getDefaultReactiveDomain(), ...) {
    # Making this a list inside a shiny::reactiveVal, instead of using a
    # shiny::reactiveValues, because it should change atomically.
    log_msg("Creating current_page reactive...")
    session$userData$shiny.router.page <- shiny::reactiveVal(list(
      path = root,
      query = NULL,
      unparsed = root
    ))
    log_msg(shiny::isolate(as.character(session$userData$shiny.router.page())))
    # Watch for updates to the address bar's fragment (aka "hash"), and update
    # our router state if needed.
    observeEvent(
      ignoreNULL = FALSE,
      ignoreInit = FALSE,
      # Shiny uses the "onhashchange" browser method (via JQuery) to detect
      # changes to the hash
      eventExpr = c(shiny::getUrlHash(session), session$clientData$url_search),
      handlerExpr = {
        log_msg("hashchange observer triggered!")
        new_hash = shiny::getUrlHash(session)
        log_msg("query not followed by hash extracted!")
        new_query = session$clientData$url_search
        log_msg("New raw hash: ", new_hash)
        cleaned_hash = cleanup_hashpath(new_hash)
        log_msg("New cleaned hash: ", cleaned_hash)
        cleaned_url = sprintf("%s%s", new_query, cleaned_hash)
        # Parse out the components of the hashpath
        parsed <- parse_url_path(cleaned_url)
        parsed$path <- ifelse(parsed$path == "", root, parsed$path)

        if (!valid_path(routes, parsed$path)) {

          log_msg("Invalid path sent to observer")
          # If it's not a recognized path, then go to default 404 page.
          change_page(PAGE_404_ROUTE, mode = "replace")

        } else if (new_hash != cleaned_hash) {

          log_msg("Cleaning up hashpath in URL...")
          change_page(cleaned_hash, mode = "replace")

        } else {

          log_msg("Path recognized!")
          # If it's a recognized path, then update the display to match.
          # TODO: Validation of routes that have mandatory query params?
          # TODO: Wildcard routes? e.g. /user/:id
          session$userData$shiny.router.page(list(
            path = parsed$path,
            query = parsed$query,
            unparsed = new_hash
          ))

        }
      }
    )

    # Switch the displayed page, if the path changes.
    output[[ROUTER_UI_ID]] <- shiny::renderUI({
      log_msg("shiny.router main output. path: ", session$userData$shiny.router.page()$path)
      routes[[session$userData$shiny.router.page()$path]][["server"]](input, output, session, ...)
      routes[[session$userData$shiny.router.page()$path]][["ui"]]
    })
  }
}

#' Creates router. Returned callback needs to be called within Shiny server code.
#'
#' @param default Main route to which all invalid routes should redirect.
#' @param ... All other routes defined with shiny.router::route function.
#' @param page_404 Styling of page when wrong bookmark is open. See \link{page404}.
#' @return Shiny router callback that should be run in server code with Shiny input and output lists.
#'
#' @examples
#' \dontrun{
#' router <- make_router(
#'   route("/", root_page),
#'   route("/other", other_page),
#'   page_404 = page404(
#'     message404 = "Please check if you passed correct bookmark name!")
#' )
#' }
#' @export
make_router <- function(default, ..., page_404 = page404()) {
  routes <- c(default, ...)
  root <- names(default)[1]
  if (! PAGE_404_ROUTE %in% names(routes) )
    routes <- c(routes, route(PAGE_404_ROUTE, page_404))
  create_router_callback(root, routes)
}

#' Creates an output for router. This configures client side.
#' Call it in your UI Shiny code. In this output ui is going to be rendered
#' according to current routing.
#'
#' @return Shiny tags that configure router and build reactive but hidden input _location.
#'
#' @import shiny
#' @examples
#' \dontrun{
#' ui <- shinyUI(fluidPage(
#'   router_ui()
#' ))
#' }
#' @export
router_ui <- function() {
  shiny::addResourcePath(
    "shiny.router",
    system.file("www", package = "shiny.router")
  )
  jsFile <- file.path("shiny.router", "shiny.router.js")

  list(
    shiny::singleton(
      shiny::withTags(
        tags$head(
          tags$script(type = "text/javascript", src = jsFile)
        )
      )
    ),
    shiny::uiOutput(ROUTER_UI_ID)
  )
}

#' Convenience function to retrieve just the "page" part of the input. This
#' corresponds to what might be called the "path" component of a URL, except
#' that we're using URLs with hashes before the path & query (e.g.:
#' http://www.example.com/#!/virtual/path?and=params)
#' @param session The current Shiny Session
#' @return The current page in a length-1 character vector, or FALSE if the input
#' has no value.
#'
#' @export
get_page <- function(session = shiny::getDefaultReactiveDomain()) {
  session$userData$shiny.router.page()$path
}

#' Is page
#'
#' Tell the reactive chain to halt if we're not on the specified page. Useful
#' for making sure we don't waste cycles re-rendering the UI for pages that are
#' not currently displayed.
#'
#' @param page The page to display. Should match one of the paths sent to the
#' @param session Shiny session
#' @param ... Other parameters are sent through to shiny::req()
#' router.
#' @export
is_page <- function(page, session = shiny::getDefaultReactiveDomain(), ...) {
  log_msg("Checking if page is: ", page);
  get_page(session) == page
}

#' Change the currently displayed page.
#'
#' Works by sending a message up to
#' our reactive input binding on the clientside, which tells page.js to update
#' the window URL accordingly, then tells clientside shiny that our reactive
#' input binding has changed, then that comes back down to our router callback
#' function and all other observers watching \code{get_page()} or similar.
#'
#' @param page The new URL to go to. Should just be the path component of the
#' URL, with optional query, e.g. "/learner?id=\%d"
#' @param session The current Shiny session.
#' @param mode ("replace" or "push") whether to replace current history or push a new one.
#' More in \code{shiny::updateQueryString}.
#'
#' @export
change_page <- function(page, session = shiny::getDefaultReactiveDomain(), mode="push") {
  log_msg("Sending page change message to client: ", page, "With page change mode: ", mode)
  shiny::updateQueryString(cleanup_hashpath(page), mode, session)
}
