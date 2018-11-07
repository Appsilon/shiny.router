library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- (
  tags$ul(
    tags$li(a(class = "item", href = route_link("/"), "Page")),
    tags$li(a(class = "item", href = route_link("other"), "Other page")),
    tags$li(a(class = "item", href = route_link("third"), "A third page"))
  )
)

# This creates UI for each page.
page <- function(title, content) {
  div(
    menu,
    titlePanel(title),
    p(content),
    dataTableOutput("table")
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!")
other_page <- page("Some other page", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

# Callbacks on the server side for
# the sample pages
root_callback <- function(input, output, session) {
  output$table <- renderDataTable({
    data.frame(x = c(1, 2), y = c(3, 4))
  })
}

other_callback <- function(input, output, session) {
  output$table <- renderDataTable({
    data.frame(x = c(5, 6), y = c(7, 8))
  })
}

# Creates router. We provide routing path, a UI as
# well as a server-side callback for each page.
router <- make_router(
  route("/", root_page, root_callback),
  route("other", other_page, other_callback),
  route("third", other_page, NA)
)

# Creat output for our router in main UI of Shiny app.
ui <- shinyUI(fluidPage(
  router_ui()
))

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  router(input, output, session)
})

# Run server in a standard way.
shinyApp(ui, server)
