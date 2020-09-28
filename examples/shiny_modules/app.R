library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- (
  tags$ul(
    tags$li(a(class = "item", href = route_link("/"), "Page")),
    tags$li(a(class = "item", href = route_link("second"), "Second page")),
    tags$li(a(class = "item", href = route_link("third"), "A third page"))
  )
)

# This creates UI for each page.
page <- function(title, content, id) {
  ns <- shiny::NS(id)
  div(
    menu,
    titlePanel(title),
    p(content),
    textOutput(ns("click_me"))
  )
}

# Both sample pages.
root_page <- page("Home page", "Converted number of clicks", "root")
second_page <- page("Second page", "Converted number of clicks", "second")
third_page <- page("Third page", "Converted number of clicks", "third")

server_callback <- function(input, output, session, clicks, power = 1) {
  output$click_me <- renderText({
    as.numeric(clicks()) ^ power
  })
}

root_callback <- function(input, output, session, clicks) {
  callModule(server_callback, "root", clicks = clicks, power = 1)
}

second_callback <- function(input, output, session, clicks) {
  callModule(server_callback, "second", clicks = clicks, power = 2)
}

third_callback <- function(input, output, session, clicks) {
  callModule(server_callback, "third", clicks = clicks, power = 3)
}

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("/", root_page, root_callback),
  route("second", second_page, second_callback),
  route("third", third_page, third_callback)
)

# Creat output for our router in main UI of Shiny app.
ui <- fluidPage(
  shiny::actionButton("clicks", "Click me!"),
  router$ui
)

# Plug router into Shiny server.
server <- function(input, output, session) {
  router$server(input, output, session, clicks = reactive(input$clicks))
}

# Run server in a standard way.
shinyApp(ui, server)
