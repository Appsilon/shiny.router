library(shiny)
library(shiny.router)

options(shiny.router.debug = TRUE)

# This generates menu in user interface with links.
menu <- tags$ul(
  tags$li(a(class = "item", href = route_link("/"), "Page")),
  tags$li(a(class = "item", href = route_link("other"), "Other page"))
)


# This creates UI for each page.
page <- function(title, content) {
  div(
    menu,
    titlePanel(title),
    p(content)
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!")
other_page <- page("Some other page", "Lorem ipsum dolor sit amet.")

# Create output for our router in main UI of Shiny app.
ui <- fluidPage(
  router_ui(
    route("/", root_page),
    route("other", other_page)
  ),
  actionButton("change", "Change query path"),
  verbatimTextOutput("url")
)

# Plug router into Shiny server.
server <- function(input, output, session) {
  router_server()
  output$url <- renderPrint(
    get_query_param()
  )
  observeEvent(input$change, {
    change_page("other?a=2")
  })
}

# Run server in a standard way.
shinyApp(ui, server)
