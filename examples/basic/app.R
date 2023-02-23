library(shiny)
library(shiny.router)

# This generates menu in user interface with links.
menu <- tags$ul(
  tags$li(a(class = "item", href = route_link("/"), "Page")),
  tags$li(a(class = "item", href = route_link("other"), "Other page")),
  tags$li(a(class = "item", href = route_link("third"), "A third page"))
)

# This creates UI for each page.
page <- function(title, content, table_id) {
  div(
    menu,
    titlePanel(title),
    p(content),
    dataTableOutput(table_id)
  )
}

# Both sample pages.
root_page <- page("Home page", "Welcome on sample routing page!", "table_one")
other_page <- page("Some other page", "Lorem ipsum dolor sit amet.", "table_two")
third_page <- div(menu, titlePanel("Third Page"))

# Make output for our router in main UI of Shiny app.
ui <- fluidPage(
  router_ui(
    route("/", root_page),
    route("other", other_page),
    route("third", third_page)
  )
)

# Plug router into Shiny server.
server <- shinyServer(function(input, output, session) {
  router_server()

  output$table_one <- renderDataTable({
    data.frame(x = c(1, 2), y = c(3, 4))
  })

  output$table_two <- renderDataTable({
    data.frame(A = c("a", "a"), B = c("b", "b"))
  })
})

# Run server in a standard way.
shinyApp(ui, server)
