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
page <- function(title, content, counter_id) {
  div(
    menu,
    titlePanel(title),
    p(content),
    textOutput(counter_id)
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!", "root_counter")
second_page <- page("Some other page", "Lorem ipsum dolor sit amet.", "second_counter")

# Callbacks on the server side for
# the sample pages
root_callback <- function(input, output, session, value) {
  output$root_counter <- renderText({
    paste("Transformed value with square", as.numeric(value()) ^ 2)
  })
}

second_callback <- function(input, output, session, value) {
  output$second_counter <- renderText({
    paste("Transformed value with cube", as.numeric(value()) ^ 3)
  })
}

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("/", root_page, root_callback),
  route("second", second_page, second_callback)
)

# Creat output for our router in main UI of Shiny app.
ui <- fluidPage(
  shiny::actionButton("clicks_common", "Number of clicks is passed to both pages and processed differently."),
  textOutput("real_number"),
  router_ui()
)

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  common_counter <- reactive({
    input$clicks_common
  })

  output$real_counter <- renderText({
    paste("Real value:", input$clicks_common)
  })

  router(input, output, session, value = common_counter)

})

# Run server in a standard way.
shinyApp(ui, server)
