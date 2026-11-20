context("router")

test_that("test route without server", {
  ui <- shiny::div("a")
  server <- function(input, output, session, ...) {} #nolint
  router_ui <- shiny::div("a", `data-path` = "aa", class = "router router-hidden ")
  rr <- route("aa", ui)
  expect_equal(rr$aa, list(ui = router_ui, server = server), check.environment = FALSE)
})


test_that("test basic get_page behaviour", {
  session <- list(userData = NULL)
  session$userData$shiny.router.page <- shiny::reactiveVal(list(
    path = "root",
    query = NULL,
    unparsed = "root"
  ))
  expect_equal(shiny::isolate(get_page(session)), "root")

  session$userData$shiny.router.page <- shiny::reactiveVal(list(
    query = NULL,
    unparsed = "root"
  ))
  expect_null(shiny::isolate(get_page(session)))
})

test_that("test basic is_page behaviour", {
  session <- list(userData = NULL)
  session$userData$shiny.router.page <- shiny::reactiveVal(list(
    path = "root",
    query = NULL,
    unparsed = "root"
  ))
  expect_true(shiny::isolate(is_page("root", session)))
  expect_false(shiny::isolate(is_page("s", session)))
})

test_that("test getting clean url hash", {
  session <- list(userData = NULL)
  session$userData$shiny.router.url_hash <-
    shiny::reactiveVal(cleanup_hashpath(""))

  expect_equal(shiny::isolate(get_url_hash(session)), "#!/")
})


test_that("test router_ui with dynamic dots", {
  default <- route("/", shiny::div("default"))
  first <- route("first", shiny::div("first"))
  second <- route("second", shiny::div("second"))

  router_ui_dynamic <- router_ui(default = default, !!!list(first, second))
  router_ui_static <- router_ui(default = default, first, second)

  expect_identical(router_ui_dynamic, router_ui_static)
})

test_that("named args in dynamic dots are ignored", {
  default <- route("/", shiny::div("default"))
  first <- route("first", shiny::div("first"))
  second <- route("second", shiny::div("second"))

  expect_warning(
    router_ui(
      default = default,
      first = first,
      second = second
    ),
    paste0(
      "Named arguments in additional routes (dynamic dots) ",
      "are not recommended and will be ignored."
    ),
    fixed = TRUE
  )

  expect_warning(
    router_ui(
      default = default,
      !!!list(
        first = first,
        second = second
      )
    ),
    paste0(
      "Named arguments in additional routes (dynamic dots) ",
      "are not recommended and will be ignored."
    ),
    fixed = TRUE
  )
})

# A mock Shiny session whose browser has the given URL hash. updateQueryString() changes the hash
# like the browser does (shiny.router.js reports hashes changed in "replace" mode too). Pages shown
# via the "switch-ui" message are collected in `shown`.
mock_router_session <- function(url_hash) {
  session <- shiny::MockShinySession$new()
  session$clientData <- shiny::reactiveValues(url_hash = url_hash, url_search = "")
  session$updateQueryString <- function(query_string, mode = "replace") {
    session$clientData$url_hash <- query_string
  }
  shown <- character()
  session$sendCustomMessage <- function(type, message) shown <<- c(shown, message)
  session$setInputs(routes = c("/", "other", PAGE_404_ROUTE))
  router <- create_router_callback("/")
  shiny::withReactiveDomain(session, router(session$input, session$output, session))
  session$flushReact()
  list(session = session, shown = function() shown)
}

test_that("a hash without the #!/ prefix is rewritten and its page is shown", {
  for (url_hash in c("#other", "#!other", "#/other")) {
    mock <- mock_router_session(url_hash)
    expect_equal(shiny::isolate(mock$session$clientData$url_hash), "#!/other")
    expect_equal(shiny::isolate(get_page(mock$session)), "other")
    expect_equal(utils::tail(mock$shown(), 1), "other")
  }
})

test_that("opening the app without a hash shows the root page once", {
  mock <- mock_router_session("")
  expect_equal(shiny::isolate(mock$session$clientData$url_hash), "#!/")
  expect_equal(shiny::isolate(get_page(mock$session)), "/")
  expect_equal(mock$shown(), "/")
})

test_that("an unknown path is rewritten to the 404 page", {
  mock <- mock_router_session("#!/missing")
  expect_equal(shiny::isolate(mock$session$clientData$url_hash), "#!/404")
  expect_equal(shiny::isolate(get_page(mock$session)), PAGE_404_ROUTE)
})
