library(shiny)
library(shiny.router)

options(shiny.router.debug = T)
# This generates menu in user interface with links.
menu <- (
  tags$ul(
    tags$li(a(class = "item", href = "/", "Page")),
    tags$li(a(class = "item", href = route_link("other"), "Other page"))
  )
)

# This creates UI for each page.
page <- function(title, content) {
  div(
    menu,
    titlePanel(title),
    p(content)
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!")
other_page <- page("Some other page", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

# Creates router. We provide routing path and UI for this page.
router <- make_router(
  route("/", root_page),
  route("other", other_page)
)

# Creat output for our router in main UI of Shiny app.
ui <- shinyUI(fluidPage(
  router_ui(),
  actionButton("button", "An action button"),
  verbatimTextOutput("url")
))

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  router(input, output, session)
  output$url <- renderPrint(
    get_query_param()
  )
  observeEvent(input$button, {
    print("aaaa")
    change_page("other?a=3&b=appsilon")
  })

})

# Run server in a standard way.
shinyApp(ui, server)