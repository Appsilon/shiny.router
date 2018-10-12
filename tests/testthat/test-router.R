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