ROUTER_UI_ID <- '_router_ui' #nolint

#' Attach 'router-hidden' class to single page UI content
#'
#' @description Covered UI types are Shiny/htmltools tags or tag lists and html templates.
#' In case of tag list (\code{tagList}) and html template (\code{htmlTemplate}) 'div' wrapper
#' with 'router-hidden' class is added.
#'
#' @param ui Single page UI content created with proper html tags or tag list.
#' @param path Single page path name. Attached to \code{data-path} attribute.
#' @keywords internal
attach_attribs <- function(ui, path) {
  if ("shiny.tag" %in% class(ui)) {
    # make pages identification easier
    ui$attribs$`data-path` <- path
    ui$attribs$class <- paste("router router-hidden", ui$attribs$class)
  }
  if ("shiny.tag.list" %in% class(ui)) {
    # make pages identification easier
    container <- shiny::div(ui)
    container$attribs$`data-path` <- path
    container$attribs$class <- "router router-hidden"
    ui <- container
  }
  ui
}

#' Create a mapping between a UI element and a server callback.
#'
#' @param path Bookmark id.
#' @param ui Valid Shiny user interface.
#' @param server Function that is called within the global server function if given
#' @return list with ui and server fields
#' @keywords internal
callback_mapping <- function(path, ui, server = NA) {
  server <- if (is.function(server)) {
    if ("..." %in% names(formals(server))) {
      server
    } else {
      # the package requires ellipsis (...) existing for each server callback
      formals(server) <- append(formals(server), alist(... = )) #nolint
      server
    }
  } else {
    function(input, output, session, ...) {} #nolint
  }
  out <- list()
  ui <- attach_attribs(ui, path)
  out[["ui"]] <- ui
  out[["server"]] <- server
  out
}

#' Internal function to get url hash with #!.
#'
#' @param session The current Shiny Session
#'
#' @return Reactive hash value.
#' @keywords internal
get_url_hash <- function(session = shiny::getDefaultReactiveDomain()) {
  session$userData$shiny.router.url_hash()
}

#' Create single route configuration.
#'
#' @param path Website route.
#' @param ui Valid Shiny user interface.
#' @param server Function that is called as callback on server side [deprecated]
#' @return A route configuration.
#' @examples
#' \dontrun{
#' route("/", shiny::tags$div(shiny::tags$span("Hello world")))
#'
#' route("main", shiny::tags$div(h1("Main page"), p("Lorem ipsum.")))
#' }
#' @export
route <- function(path, ui, server = NA) {
  if (!missing(server)) {
    warning(
      "`server` argument in `route` is deprecated.
      It will not be used when `route` is called inside `router_ui`."
    )
  }

  out <- list()
  out[[path]] <- callback_mapping(path, ui, server)
  out
}

#' Internal function creating a router callback function.
#' One need to call router callback with Shiny input and output in server code.
#'
#' @param root Main route to which all invalid routes should redirect.
#' @param routes A routes (list).
#'
#' @return Router callback.
#' @keywords internal
create_router_callback <- function(root, routes = NULL) {
  function(input, output, session = shiny::getDefaultReactiveDomain(), ...) {
    # Making this a list inside a shiny::reactiveVal, instead of using a
    # shiny::reactiveValues, because it should change atomically.
    log_msg("Creating current_page reactive...")
    session$userData$shiny.router.page <- shiny::reactiveVal(list(
      path = root,
      query = NULL,
      unparsed = root
    ))

    # Watch and clean hash before changing page.
    session$userData$shiny.router.url_hash <- shiny::reactiveVal("#!/")
    shiny::observeEvent(shiny::getUrlHash(), {
      session$userData$shiny.router.url_hash(cleanup_hashpath(shiny::getUrlHash()))
    })

    if (!is.null(routes)) {
      lapply(routes, function(route) route$server(input, output, session, ...))
    }

    # Watch for updates to the address bar's fragment (aka "hash"), and update
    # our router state if needed.
    shiny::observeEvent(
      ignoreNULL = FALSE,
      ignoreInit = FALSE,
      # Shiny uses the "onhashchange" browser method (via JQuery) to detect
      # changes to the hash
      eventExpr = c(get_url_hash(session), session$clientData$url_search, input$routes),
      handlerExpr = {
        log_msg("hashchange observer triggered!")
        new_hash <- shiny::getUrlHash(session)
        log_msg("query not followed by hash extracted!")
        new_query <- session$clientData$url_search
        log_msg("New raw hash: ", new_hash)
        cleaned_hash <- cleanup_hashpath(new_hash)
        if (cleaned_hash == "#!/") {
          cleaned_hash <- cleanup_hashpath(root)
        }
        log_msg("New cleaned hash: ", cleaned_hash)
        cleaned_url <- sprintf("%s%s", new_query, cleaned_hash)
        # Parse out the components of the hashpath
        parsed <- parse_url_path(cleaned_url)
        parsed$path <- ifelse(parsed$path == "", root, parsed$path)

        is_path_valid <- if (is.null(routes)) {
          shiny::req(input$routes)
          log_msg("Valid paths:", input$routes)
          !is.null(input$routes) && !(parsed$path %in% c(input$routes, "404"))
        } else {
          !valid_path(routes, parsed$path)
        }

        if (is_path_valid) {
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

    shiny::observeEvent(session$userData$shiny.router.page(), {
      page_path <- session$userData$shiny.router.page()$path
      log_msg("shiny.router main output. path: ", page_path)
      session$sendCustomMessage("switch-ui", page_path)
    })
  }
}

#' Create router UI
#'
#' Creates router UI in Shiny applications.
#'
#' @param default Main route to which all invalid routes should redirect.
#' @param ...
#'   All other routes defined with shiny.router::route function.
#'   It's possible to pass routes in dynamic way with dynamic dots.
#'   See \code{\link[rlang:dots_list]{dynamic-dots}} and example below
#' @param page_404 Styling of page when invalid route is open. See \link{page404}.
#' @param env Environment (only for advanced usage), makes it possible to use shiny.router inside
#'   shiny modules.
#'
#' @details If you are defining the router inside a shiny module,
#'   we assume that the namespacing function defined in the UI is named as \code{ns}.
#'
#' @return Application UI wrapped in a router.
#'
#' @examples
#' \dontrun{
#'   ui <- function() {
#'     router_ui(
#'       route("/", root_page(id = "root")),
#'       route("other", other_page(id = "other")),
#'       page_404 = page404(
#'         message404 = "Please check if you passed correct bookmark name!")
#'     )
#'   }
#' }
#' \dontrun{
#'   # create the list of routes
#'   dynamic_routes <- list(
#'     route("other2", other_page(id = "other2")),
#'     route("other3", other_page(id = "other3"))
#'   )
#'
#'   ui <- function() {
#'     router_ui(
#'       route("/", root_page(id = "root")),
#'       route("other", other_page(id = "other")),
#'       # then it's possible to inject a list of arguments into a function call using rlang::`!!!`
#'       !!!dynamic_routes,
#'       page_404 = page404(
#'         message404 = "Please check if you passed correct bookmark name!")
#'     )
#'   }
#' }
#' @export
router_ui <- function(default, ..., page_404 = page404(), env = parent.frame()) {
  args <- rlang::list2(...)
  if (!is.null(names(args))) {
    warning(
      paste0(
        "Named arguments in additional routes (dynamic dots) ",
        "are not recommended and will be ignored."
      )
    )
    names(args) <- NULL
  }
  paths <- unlist(args, recursive = FALSE)
  routes <- c(default, paths)
  root <- names(default)[1]
  if (! PAGE_404_ROUTE %in% names(routes))
    routes <- c(routes, route(PAGE_404_ROUTE, page_404))
  router <- list(root = root, routes = routes)

  routes_input_id <- "routes"
  if (!is.null(env$ns)) {
    routes_input_id <- env$ns(routes_input_id)
  }

  routes_names <- paste0("'", names(routes), "'", collapse = ", ")

  shiny::tagList(
    shiny::tags$script(
      glue::glue("$(document).on('shiny:connected', function() {{
        Shiny.setInputValue('{routes_input_id}', [{routes_names}]);
      }});")
    ),
    router_ui_internal(router)
  )
}

#' Create router pages server callback
#'
#' Server part of the router.
#'
#' @param root_page Main page path.
#' @param env Environment (only for advanced usage).
#'
#' @return Router pages server callback.
#'
#' @examples
#' \dontrun{
#'   server <- function(input, output, session) {
#'     router_server(root_page = "/")
#'   }
#' }
#' @export
router_server <- function(root_page = "/", env = parent.frame()) {
  router <- create_router_callback(root_page)
  router(env$input, env$output, env$session)
}

#' Create router pages server callback
#'
#' @param router Router pages object. See \link{make_router}.
#' @keywords internal
router_server_internal <- function(router) {
  create_router_callback(router$root, router$routes)
}

#' Creates router UI
#'
#' @param router Router pages object. See \link{make_router}.
#'
#' @return list with shiny tags that adds "router-page-wrapper" div and embeds
#' router JavaScript script.
#' @keywords internal
router_ui_internal <- function(router) {
  shiny::addResourcePath(
    "shiny.router",
    system.file("www", package = "shiny.router")
  )
  js_file <- file.path("shiny.router", "shiny.router.js")
  css_file <- file.path("shiny.router", "shiny.router.css")

  list(
    shiny::singleton(
      shiny::withTags(
        shiny::tags$head(
          shiny::tags$script(type = "text/javascript", src = js_file),
          shiny::tags$link(rel = "stylesheet", href = css_file)
        )
      )
    ),
    shiny::tags$div(
      id = "router-page-wrapper",
      lapply(router$routes, function(route) route$ui)
    )
  )
}

#' [Deprecated] Creates router.
#'
#' Returned callback needs to be called within Shiny server code.
#'
#' @param default Main route to which all invalid routes should redirect.
#' @param ... All other routes defined with shiny.router::route function.
#' @param page_404 Styling of page when wrong bookmark is open. See \link{page404}.
#' @return Shiny router callback that should be run in server code with Shiny input and output
#'   lists.
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
  .Deprecated(
    new = "router_ui",
    msg = "make_router function is deprecated. Please use 'router_ui' instead."
  )

  routes <- c(default, ...)
  root <- names(default)[1]
  if (! PAGE_404_ROUTE %in% names(routes))
    routes <- c(routes, route(PAGE_404_ROUTE, page_404))
  router <- list(root = root, routes = routes)
  list(ui = router_ui_internal(router), server = router_server_internal(router))
}

#' Convenience function to retrieve just the "page" part of the input.
#'
#' This corresponds to what might be called the "path" component of a URL, except
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
#' @param ... Other parameters are sent through to \code{shiny::req()}
#' router.
#' @export
is_page <- function(page, session = shiny::getDefaultReactiveDomain(), ...) {
  log_msg("Checking if page is: ", page)
  get_page(session) == page
}

#' Change the currently displayed page.
#'
#' Works by sending a message up to
#' our reactive input binding on the client side, which tells page.js to update
#' the window URL accordingly, then tells client side shiny that our reactive
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
change_page <- function(page, session = shiny::getDefaultReactiveDomain(), mode = "push") {
  log_msg("Sending page change message to client: ", page, "With page change mode: ", mode)
  shiny::updateQueryString(cleanup_hashpath(page), mode, session)
}
