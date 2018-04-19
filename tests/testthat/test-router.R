context("router")

## TODO: Add more tests

test_that("test route", {
  rr <- route("aa", shiny::div("a"))
  expect_equal(rr$aa, shiny::div("a"))
  expect_error(route("aa"), "argument \"ui\" is missing, with no default")
})