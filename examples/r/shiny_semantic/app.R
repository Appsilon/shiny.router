library(shiny)
library(shiny.semantic)
library(shiny.router)

# Hint: shiny.semantic
#
# Div classes in the UI of this applications are created for shiny.semantic package.
# Thanks to that we get nice looking interface in our application.
# Read more: https://appsilon.github.io/shiny.semantic/

menu <- div(
  class = "ui vertical menu",
  div(
    class = "item",
    div(class = "header", "Demo"),
    div(
      class = "menu",
      a(class = "item", href = route_link("index"), icon("home"), "Page"),
      a(class = "item", href = route_link("other"), icon("clock"), "Other")
    )
  )
)

page <- function(title, content) {
  div(
    class = "ui container",
    style = "margin-top: 1em",
    div(
      class = "ui grid",
      div(
        class = "four wide column",
        menu
      ),
      div(
        class = "twelve wide column",
        div(
          class = "ui segment",
          h1(title),
          p(content)
        )
      )
    )
  )
}

root_page <- page("Home page", "Welcome on sample routing page!")
other_page <- page("Some other page", "Lorem ipsum dolor sit amet.")

ui <- semanticPage(
  title = "Router demo",
  router_ui(
    route("index", root_page),
    route("other", other_page)
  )
)

server <- function(input, output, session) {
  router_server("index")
}

shinyApp(ui, server)
