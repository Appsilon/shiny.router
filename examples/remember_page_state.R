library(shiny)
library(shiny.semantic)
library(shiny.router)

# TODO adjust to new version of shiny.router

# Hint: semanticui
#
# Div classes in the UI of this applications are created for semanticui package.
# Thanks to that we get nice looking interface in our application.
# Read more: https://github.com/Appsilon/semanticui

menu <- (
  div(class = "ui vertical menu",
      div(class = "item",
          div(class = "header", "Demo"),
          div(class = "menu",
              a(class = "item", href = route_link("/"), icon("home"), "Page"),
              a(class = "item", href = route_link("other"), icon("clock"), "Other"),
              a(class = "item", href = route_link("ui"), icon("clock"), "UI")
          )
      )
  )
)

page_content <- function(title, content) {
  div(
      h1(title),
      p(content)
  )
}

root_page <- page_content("Home page", actionButton("button", "Click me!"))
other_page <- page_content("Some other page", textInput("text", "Type something here"))
ui_page <- page_content("UI page", uiOutput("oko"))

router <- make_router(
  route("index", root_page),
  route("other", other_page),
  route("ui", ui_page)
)

ui <- semanticPage(
  title = "Router demo",
  div(class = "ui container",
      style = "margin-top: 1em",
      div(class = "ui grid",
          div(class = "four wide column",
              menu
          ),
          div(class = "twelve wide column",
              router$ui
          )
      )
  )
)

server <- shinyServer(function(input, output, session) {
  router$server(input, output, session)
  output$oko <- renderUI({
    div("Hello there")
  })
})

shinyApp(ui, server)
