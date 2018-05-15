library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- (
  tags$ul(
    tags$li(a(class = "item", href = route_link("/"), "Page")),
    tags$li(a(class = "item", href = route_link("second"), "Second page")),
    tags$li(a(class = "item", href = route_link("third"), "A third page")),
    tags$li(a(class = "item", href = route_link("fourth"), "A fourth page"))
  )
)

# This creates UI for each page.
page <- function(title, content) {
  div(
    menu,
    titlePanel(title),
    p(content),
    textOutput("click_me")
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!")
second_page <- page("Some other page", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

# Callbacks on the server side for
# the sample pages
second_callback <- function(input, output, session) {
  output$click_me <- renderText({
    as.numeric(input$clicks) ^ 2
  })
}

third_callback <- function(input, output, session) {
  output$click_me <- renderText({
    as.numeric(input$clicks) ^ 3
  })
}

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("/", root_page, NA),
  route("second", second_page, second_callback),
  route("third", second_page, third_callback),
  route("fourth", second_page, NA)
)

# Creat output for our router in main UI of Shiny app.
ui <- shinyUI(fluidPage(
  shiny::actionButton("clicks", "Click me!"),
  router_ui()
))

# Plug router into Shiny server.
server <- shinyServer(function(input, output) {
  router(input, output)
  output$click_me <- renderText({
    as.numeric(input$clicks)
  })
})

# Run server in a standard way.
shinyApp(ui, server)
