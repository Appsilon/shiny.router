ROUTER_UI_ID <- '_router_ui'
HIDDEN_ROUTE_INPUT <- '_location'

.onLoad <- function(libname, pkgname) {
  # Adds inst/www directory for loading static resources from server.
  # We need to add that to get all javascript code from client app.
  shiny::addResourcePath('shiny.router', system.file('www/bower_components/page/', package = 'shiny.router', mustWork = TRUE))
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

callback_mapping <- function(ui, server = NA) {
  out <- list()
  out[["ui"]] <- ui
  out[["server"]] <- server
  out
}

#' Create single route configuration.
#'
#' @param path Website route.
#' @param ui Valid Shiny user interface.
#' @param server Function that is called as callback on server side
#' @return A route configuration.
#' @examples
#' route("/", shiny::tags$div(shiny::tags$span("Hello world")))
#'
#' route("/main", div(h1("Main page"), p("Lorem ipsum.")))
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
#' @return Router callback.
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
        routes[[location]][["server"]](input, output)
        routes[[location]][["ui"]]
      } else {
        routes[[root]][["server"]](input, output)
        routes[[root]][["ui"]]
      }
    })
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
    shinyjs::useShinyjs(),
    shiny::singleton(
      shiny::tags$head(
        shiny::tags$script(src = "shiny.router/page.js")
      )
    ),
    shiny::uiOutput(ROUTER_UI_ID),
    shiny::textInput(HIDDEN_ROUTE_INPUT, label = ""),
    shiny::tags$style(paste0("#", HIDDEN_ROUTE_INPUT, " {display: none;}"))
  )
}

