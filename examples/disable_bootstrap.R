library(shiny)
library(shiny.router)
library(shiny.semantic)

# Both sample pages.
bootstrap_page <- fluidPage(
  tags$head(
    singleton(disable_bootstrap_on_bookmark("semanticui"))
  ),
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::sliderInput("obs",
                  "Number of observations:",
                  min = 0,
                  max = 1000,
                  value = 500)
    ),
    shiny::mainPanel(
      plotOutput("distPlot")
    )
  )
)

semanticui_page <- semanticPage(
  title = "Dropdown example",
  uiOutput("dropdown"),
  p("Selected letter:"),
  textOutput("selected_letter")
)

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("bootstrap", bootstrap_page),
  route("semantic", semanticui_page)
)

# Creat output for our router in main UI of Shiny app.
ui <- shinyUI(
  router$ui
)

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  router$server(input, output, session)

  output$dropdown <- renderUI({
    dropdown_input("simple_dropdown", LETTERS, value = "A")
  })

  output$distPlot <- renderPlot({
    req(input$obs)
    hist(rnorm(input$obs))
  })

  output$selected_letter <- renderText(input[["simple_dropdown"]])
})

# Run server in a standard way.
shinyApp(ui, server)
