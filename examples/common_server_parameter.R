library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- (
  tags$ul(
    tags$li(a(class = "item", href = route_link("/"), "Page")),
    tags$li(a(class = "item", href = route_link("second"), "Second page"))
  )
)

# This creates UI for each page.
page <- function(title, content) {
  div(
    menu,
    titlePanel(title),
    p(content),
    textOutput("server_own_counter"),
    textOutput("server_common_counter")
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!")
second_page <- page("Some other page", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

# Callbacks on the server side for
# the sample pages
root_callback <- function(input, output, session, value) {
  output$server_own_counter <- renderText({
    as.numeric(input$clicks_separate) ^ 2
  })
  output$server_common_counter <- renderText({
    as.numeric(value())
  })
}

second_callback <- function(input, output, session, value) {
  output$server_own_counter <- renderText({
    as.numeric(input$clicks_separate) ^ 3
  })
  output$server_common_counter <- renderText({
    as.numeric(value())
  })
}

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("/", root_page, root_callback),
  route("second", second_page, second_callback)
)

# Creat output for our router in main UI of Shiny app.
ui <- shinyUI(fluidPage(
  shiny::actionButton("clicks_separate", "Each router callback counts me differently!"),
  shiny::actionButton("clicks_common", "My counter is passed to both router callbacks!"),
  router_ui()
))

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  common_counter <- reactive({
    input$clicks_common
  })

  router(input, output, session, value = common_counter)

})

# Run server in a standard way.
shinyApp(ui, server)
