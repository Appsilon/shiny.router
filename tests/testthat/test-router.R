context("router")

## TODO: Add more tests

test_that("test route_link", {
  expect_equal(route_link("#!/abc"), "/#!/abc")
  expect_equal(route_link("abc"), "/#!/abc")
})