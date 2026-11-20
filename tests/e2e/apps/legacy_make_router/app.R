# The deprecated make_router() API. Unlike router_server(), it checks paths against the routes
# it was given (not the "routes" input) and calls each route's server function.
library(shiny)
library(shiny.router)

home_page <- div(id = "home_page", h1("Legacy home"))
other_page <- div(id = "other_page", h1("Legacy other"), textOutput("other_text"))
other_server <- function(input, output, session) {
  output$other_text <- renderText("Rendered by the route's server")
}

router <- suppressWarnings(make_router(
  route("/", home_page),
  route("other", other_page, other_server)
))

ui <- fluidPage(router$ui)

server <- function(input, output, session) {
  router$server(input, output, session)
}

shinyApp(ui, server)
