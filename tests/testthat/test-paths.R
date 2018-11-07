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
