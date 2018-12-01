context("router")

## TODO: Add more tests

test_that("test route without server", {
  ui <- shiny::div("a")
  server <- function(input, output, session, ...){}
  rr <- route("aa", ui)
  expect_equal(rr$aa, list(ui = ui, server = server))
  expect_error(route("aa"))
})

test_that("test route with server", {
  ui <- shiny::div("a")
  server <- function(input, output, session, ...){
    output$val <- renderText("Hello")
    }
  rr <- route("aa", ui, server)
  expect_equal(rr$aa, list(ui = ui, server = server))
})

test_that("test basic make_router behaviour", {
  # wrong nr of arguments
  expect_error(make_router())
  # chcking if output is a function
  router <- make_router(
    route("/", shiny::div("a")),
    route("/other", shiny::div("b")),
    page_404 = page404(message404 = "404")
  )
  expect_equal(typeof(router), "closure")
})
