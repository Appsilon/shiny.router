library(shiny)
library(shinyjs)
library(semanticui)
library(magrittr)
library(shinyrouter)

js <- "
$('.ui.sidebar').sidebar('toggle');
"

menu <- (
  div(class = "ui vertical menu",
    div(class = "item",
        div(class = "header", "Demo"),
        div(class = "menu",
            a(class = "item", href = "/", uiicon("home"), "Page"),
            a(class = "item", href = "/other", uiicon("clock"), "Other")
        )
    )
  )
)

onePage <- (
  div(class = "ui container",
      style = "margin-top: 1em",
      div(class = "ui grid",
          div(class = "four wide column",
              menu
          ),
          div(class = "twelve wide column",
              div(class = "ui segment",
                  h1("Main page"),
                  div(class = "ui card", div(class = "content",
                                             div(class = "right floated meta", "14h"),
                                             img(class = "ui avatar image", src = "http://semantic-ui.com/images/avatar/large/elliot.jpg"),
                                             "Elliot"), div(class = "image", img(src = "http://semantic-ui.com/images/wireframe/image.png")),
                      div(class = "content", span(class = "right floated",
                                                  uiicon("heart outline like"), "17 likes"),
                          uiicon("comment"), "3 comments"),
                      div(class = "extra content", div(class = "ui large transparent left icon input",
                                                       uiicon("heart ouline"), tags$input(type = "text",
                                                                                          placeholder = "Add Comment..."))))
              )
          )
      )
  )
)

otherPage <- (
  div(class = "ui container",
      style = "margin-top: 1em",
      div(class = "ui grid",
          div(class = "four wide column",
              menu
          ),
          div(class = "twelve wide column",
              div(class = "ui segment",
                  h1("Other"),
                  p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
              )
          )
      )
  )
)

router <- make_router(
  route("/", onePage),
  route("/other", otherPage)
)

ui <- shinyUI(semanticPage(
  title = "Router demo",
  router_ui()
))

server <- shinyServer(function(input, output) {
  runjs(js)
  router(input, output)
})

shinyApp(ui, server)
