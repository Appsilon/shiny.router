context("paths")

test_that("test cleanup_hashpath", {
  expect_equal(cleanup_hashpath("#!/abc"), "#!/abc")
  expect_equal(cleanup_hashpath("#!abc"), "#!/abc")
  expect_equal(cleanup_hashpath("#/abc"), "#!/abc")
  expect_equal(cleanup_hashpath("#/xyz"), "#!/xyz")
})

test_that("test extract_link_name", {
  expect_equal(extract_link_name("#!/abc"), "abc")
  expect_equal(extract_link_name("abc"), "abc")
})

test_that("test route_link", {
  expect_equal(route_link("abc"), "./#!/abc")
  expect_equal(route_link("#/xyzq"), "./#!/xyzq")
})

test_that("test parse_url_path", {
  p <- parse_url_path("?a=1&b=foo#!/")
  expect_error(parse_url_path())
  expect_equal(p$path, "")
  expect_equal(p$query$b, "foo")
  p <- parse_url_path("www.foo.bar/?a=1&b[1]=foo&b[2]=bar")
  expect_true(length(p$query$b) == 2)
  expect_equal(p$query$b[[2]], "bar")
})

test_that("test valid_path", {
  expect_error(valid_path())
  expect_true(valid_path(list(a="a", b="b"), "b"))
  expect_false(valid_path(list(a="a", c="b"), "b"))
  expect_false(valid_path(list(), "b"))
})

test_that("test get_query_param parameters", {
  session <- list(userData = NULL)
  session$userData$shiny.router.page <- shiny::reactiveVal(list(
    path = "root",
    query = list(one = 1, two = 2),
    unparsed = "root"
  ))
  expect_error(shiny::isolate(get_query_param()))
  expect_equal(shiny::isolate(get_query_param("one", session)), 1)
  expect_failure(
    expect_equal(shiny::isolate(get_query_param("two", session)), 1)
  )
  expect_equal(shiny::isolate(get_query_param(session =  session)),
               list(one = 1, two = 2))
})
