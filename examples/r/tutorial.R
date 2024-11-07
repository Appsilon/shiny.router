library(shiny)
library(shiny.router)

home_page <- div(
  titlePanel("Home page"),
  p("This is the home page!"),
  uiOutput("power_of_input")
)

another_page <- div(
  titlePanel("Another page"),
  p("This is the another page!"),
)

menu <- tags$ul(
  tags$li(a(class = "item", href = route_link("/"), "Main")),
  tags$li(a(class = "item", href = route_link("another"), "Another page")),
)

ui <- fluidPage(
  menu,
  tags$hr(),
  router_ui(
    route("/", home_page),
    route("another", another_page)
  ),
  sliderInput("int", "Choose integer:", -10, 10, 1, 1),
)

server <- function(input, output, session) {
  router_server()

  component <- reactive({
    if (is.null(get_query_param()$add)) {
      return(0)
    }
    as.numeric(get_query_param()$add)
  })

  output$power_of_input <- renderUI({
    HTML(paste(
      "I display input increased by <code>add</code> GET parameter from app url and pass result to <code>output$power_of_input</code>: ",
      as.numeric(input$int) + component()))
  })
}

shinyApp(ui, server)
