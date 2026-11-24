# router_ui() rendered from the server (#79): the routes depend on the session, so the HTML of a
# route the user may not see never reaches the browser.
library(shiny)
library(shiny.router)

ui <- fluidPage(
  checkboxInput("admin", "Admin"),
  actionButton("rerender", "Re-render with the same routes"),
  tags$ul(
    tags$li(a(id = "link_home", href = route_link("/"), "Home")),
    tags$li(a(id = "link_other", href = route_link("other"), "Other")),
    tags$li(a(id = "link_admin", href = route_link("admin"), "Admin"))
  ),
  uiOutput("router"),
  textOutput("current_page")
)

server <- function(input, output, session) {
  router_server()
  output$router <- renderUI({
    input$rerender
    routes <- list(route("other", div(id = "other_page", h1("Other page"))))
    if (isTRUE(input$admin)) {
      routes <- c(routes, list(route("admin", div(id = "admin_page", h1("Admin page")))))
    }
    router_ui(
      route("/", div(id = "home_page", h1("Home page"))),
      !!!routes,
      page_404 = page404(message404 = "No such page")
    )
  })
  output$current_page <- renderText(get_page())
}

shinyApp(ui, server)
