context("misc")

## TODO: Add more tests

test_that("test check_hashpath", {
  expect_true(check_hashpath("#!/abc"))
  expect_false(check_hashpath("abc"))
  expect_false(check_hashpath("#abc"))
  expect_false(check_hashpath("!xyz"))
})

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

