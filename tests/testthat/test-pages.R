context("pages")

test_that("test page404", {
  expect_equal(class(page404()), "shiny.tag")
  expect_match(as.character(page404()), "Not found")
  expect_match(as.character(page404()), "div")
  expect_equal(page404(shiny::div("AA")), shiny::div("AA"))
  expect_equal(page404(message404 = "ABC"), shiny::div(shiny::h1("ABC")))
})