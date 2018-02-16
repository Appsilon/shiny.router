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
