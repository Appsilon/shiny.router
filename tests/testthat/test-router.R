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
  first <- route("/first", shiny::div("first"))
  second <- route("/second", shiny::div("second"))

  router_ui_dynamic <- router_ui(default = default, !!!list(first, second))
  router_ui_static <- router_ui(default = default, first, second)

  expect_identical(router_ui_dynamic, router_ui_static)
})

test_that("named args in dynamic dots are ignored", {
  default <- route("/", shiny::div("default"))
  first <- route("/first", shiny::div("first"))
  second <- route("/second", shiny::div("second"))

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
