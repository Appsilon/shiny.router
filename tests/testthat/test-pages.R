context("pages")

test_that("test page404", {
  expect_equal(class(page404()), "shiny.tag")
  expect_match(as.character(page404()), "Not found")
  expect_match(as.character(page404()), "div")
  expect_equal(page404(shiny::div("AA")), shiny::div("AA"))
  expect_equal(page404(message404 = "ABC"), shiny::div(shiny::h1("ABC")))
})

test_that("test disable_bootstrap_on_bookmark", {
  disable_test_bookmark <- disable_bootstrap_on_bookmark("test_bookmark")
  expect_true("shiny.tag.list" %in% class(disable_test_bookmark))
  expect_equal(names(attributes(disable_test_bookmark[[1]][[1]])), "html_dependencies")
  expect_equal(disable_test_bookmark[[2]]$name, "div")
  expect_equal(attr(disable_test_bookmark[[2]], "htmltools.singleton"), TRUE)
  expect_equal(disable_test_bookmark[[3]]$name, "script")
  expect_equal(disable_test_bookmark[[4]]$name, "script")
  expect_match(as.character(disable_test_bookmark[[4]]), "test_bookmark")
})
