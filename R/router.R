ROUTER_UI_ID <- '_router_ui'
HIDDEN_ROUTE_INPUT <- '_location'

.onLoad <- function(libname, pkgname) {
  # Adds inst/www directory for loading static resources from server.
  # We need to add that to get all javascript code from client app.
  shiny::addResourcePath('shinyrouter', system.file('www/bower_components/page/', package = 'shinyrouter', mustWork = TRUE))
}

escape_path <- function(path) {
  clean_path <- gsub("'", "%27", path, fixed = T)
  clean_path <- gsub("\\", "%5C", path, fixed = T)
  clean_path
}

#' Validates that path is defined in routes.
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
#' @export
route <- function(path, ui) {
  out <- list()
  out[[path]] <- ui
  out
}

create_router_callback <- function(root, routes) {
  function(input, output) {
    initialize_router <- shiny::reactive({
      initialize_code_buffer <- ""
      for (path in names(routes)) {
        if (substr(path, 1, 1) == "/") {
          clean_path <- escape_path(path)
          register_code <- paste0("page('", clean_path, "', function() { $('#", HIDDEN_ROUTE_INPUT, "').val('", clean_path, "').keyup(); });\n")
          initialize_code_buffer <- paste0(initialize_code_buffer, register_code)
        }
      }
      register_code <- paste0(
        "page('*', function() { page.redirect('", escape_path(root), "'); });",
        "page({ hashbang:true });"
      )
      initialize_code_buffer <- paste0(initialize_code_buffer, register_code)
      shinyjs::runjs(initialize_code_buffer)
    })

    output[[ROUTER_UI_ID]] <- shiny::renderUI({
      initialize_router()
      location <- input[[HIDDEN_ROUTE_INPUT]]
      if (valid_path(routes, location)) {
        routes[[location]]
      } else {
        routes[[root]]
      }
    })
  }
}

#' Creates router.
#'
#' @return Shiny router callback that should be run in server code with Shiny input and output lists.
#' @export
make_router <- function(default, ...) {
  routes <- c(default, ...)
  root <- names(default)[1]
  create_router_callback(root, routes)
}

#' Creates an output for router. This configures client side.
#'
#' @return Shiny tags that configure router and build reactive input _location.
#' @export
router_ui <- function() {
  shiny::tagList(
    shinyjs::useShinyjs(),
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src = "shinyrouter/page.js")
      )
    ),
    shiny::uiOutput(ROUTER_UI_ID),
    shiny::textInput(HIDDEN_ROUTE_INPUT, label = ""),
    shiny::tags$style(paste0("#", HIDDEN_ROUTE_INPUT, " {display: none;}"))
  )
}

