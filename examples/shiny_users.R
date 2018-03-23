library(shiny)
library(shiny.users)
library(shiny.semantic)
library(tibble)
library(shiny.router)

mock_users <- data.frame(
  username = c("test"),
  password = c("test")
)

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
    uiOutput("authorized_content"),
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

ui <- shinyUI(fluidPage(
  div(class = "container",
      style = "padding: 4em",
      login_screen_ui("login_screen"),
      router_ui()
  )
))


server <- shinyServer(function(input, output, session) {
  router(input, output, session)
  users <- initialize_users(mock_users)
  callModule(login_screen, "login_screen", users, login_form = shiny.users::semantic_login_form, logout_form = NULL)

  output$authorized_content <- renderUI({
     if (!is.null(users$user())) {
      print(users$user())
      div(style="border: 1px solid #f00",
        actionButton("button", "An action button"),
        verbatimTextOutput("url"))
     }
  })

  output$url <- renderPrint({
    print("url")
    get_query_param()
  })
})

shinyApp(ui, server)
