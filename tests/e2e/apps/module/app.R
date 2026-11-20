# The router inside a Shiny module, with a named root page ("home" instead of "/").
# router_ui() namespaces its "routes" input with the module's `ns`.
library(shiny)
library(shiny.router)

router_module_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$ul(
      tags$li(a(id = ns("link_home"), href = route_link("home"), "Home")),
      tags$li(a(id = ns("link_other"), href = route_link("other"), "Other"))
    ),
    router_ui(
      route("home", div(id = ns("home_page"), h1("Module home"))),
      route("other", div(id = ns("other_page"), h1("Module other"), textOutput(ns("other_text"))))
    ),
    textOutput(ns("current_page"))
  )
}

router_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    router_server(root_page = "home")
    output$current_page <- renderText(get_page())
    output$other_text <- renderText(if (is_page("other")) "Rendered for the other page")
  })
}

ui <- fluidPage(router_module_ui("nav"))

server <- function(input, output, session) {
  router_module_server("nav")
}

shinyApp(ui, server)
