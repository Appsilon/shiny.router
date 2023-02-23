library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- tags$ul(
  tags$li(a(class = "item", href = route_link("/"), "Page")),
  tags$li(a(class = "item", href = route_link("second"), "Second page")),
  tags$li(a(class = "item", href = route_link("third"), "A third page"))
)

# This creates UI for each page.
page <- function(title, content, id) {
  ns <- NS(id)
  div(
    titlePanel(title),
    p(content),
    textOutput(ns("click_me"))
  )
}

# Both sample pages.
root_page <- page("Home page", "Converted number of clicks", "root")
second_page <- page("Second page", "Converted number of clicks", "second")
third_page <- page("Third page", "Converted number of clicks", "third")

server_module <- function(id, clicks, power = 1) {
  moduleServer(id, function(input, output, session) {
    output$click_me <- renderText({
      as.numeric(clicks())^power
    })
  })
}

# Create output for our router in main UI of Shiny app.
ui <- fluidPage(
  menu,
  actionButton("clicks", "Click me!"),
  router_ui(
    route("/", root_page),
    route("second", second_page),
    route("third", third_page)
  )
)

# Plug router into Shiny server.
server <- function(input, output, session) {
  router_server()

  clicks <- reactive({
    input$clicks
  })

  server_module("root", clicks = clicks)
  server_module("second", clicks = clicks, power = 2)
  server_module("third", clicks = clicks, power = 3)
}

# Run server in a standard way.
shinyApp(ui, server)
