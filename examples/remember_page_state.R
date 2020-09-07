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
              a(class = "item", href = route_link("other"), icon("clock"), "Other")
          )
      )
  )
)

page <- function(title, content) {
  div(class = "ui container",
      style = "margin-top: 1em",
      div(class = "ui grid",
          div(class = "four wide column",
              menu
          ),
          div(class = "twelve wide column",
              div(class = "ui segment",
                  h1(title),
                  p(content)
              )
          )
      )
  )
}

root_page <- page("Home page", actionButton("button", "Click me!"))
other_page <- page("Some other page", textInput("text", "Type something here"))

router <- make_router(
  route("index", root_page),
  route("other", other_page)
)

ui <- shinyUI(semanticPage(
  title = "Router demo",
  "Hello",
  router$ui
))

server <- shinyServer(function(input, output, session) {
  router$server(input, output, session)
})

shinyApp(ui, server)
