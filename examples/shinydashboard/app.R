## app.R ##
library(shinydashboard)
library(shiny)
library(shiny.router)

dashboard <- fluidRow(
  box(plotOutput("plot1", height = 250)),
  
  box(
    title = "Controls",
    sliderInput("slider", "Number of observations:", 1, 100, 50)
  )
)

widgets <- h2("Widgets tab content")

router <- make_router(
  route("dashboard", dashboard),
  route("widgets", widgets)
)

ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", icon = icon("dashboard"), href = route_link("dashboard"), newtab = FALSE),
      menuItem("Widgets", icon = icon("th"), href = route_link("widgets"), newtab = FALSE)
    )
  ),
  dashboardBody(
    router_ui()
  )
)

server <- function(input, output, session) {
  router(input, output, session)
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)

