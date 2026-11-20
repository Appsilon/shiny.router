# Routing with the router_ui() / router_server() API: links, deep links, the 404 page,
# server-side change_page() with a query string, and what the server sees (get_page(),
# get_query_param(), is_page()).
library(shiny)
library(shiny.router)

menu <- tags$ul(
  tags$li(a(id = "link_home", href = route_link("/"), "Home")),
  tags$li(a(id = "link_other", href = route_link("other"), "Other")),
  tags$li(a(id = "link_missing", href = route_link("missing"), "Missing"))
)

ui <- fluidPage(
  menu,
  router_ui(
    route("/", div(id = "home_page", h1("Home page"))),
    route("other", div(id = "other_page", h1("Other page"))),
    page_404 = page404(message404 = "No such page")
  ),
  actionButton("go_other", "Go to other with a query"),
  # What the server sees.
  textOutput("current_page"),
  textOutput("query"),
  textOutput("on_other")
)

server <- function(input, output, session) {
  router_server()
  observeEvent(input$go_other, change_page("other?id=42&tab=b"))
  output$current_page <- renderText(get_page())
  output$query <- renderText({
    query <- get_query_param()
    paste(names(query), unlist(query), sep = "=", collapse = "&")
  })
  output$on_other <- renderText(is_page("other"))
}

shinyApp(ui, server)
