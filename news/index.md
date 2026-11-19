# Changelog

## shiny.router 0.3.1

CRAN release: 2023-04-18

- Changed the dots (`...`) argument in
  [`router_ui()`](https://appsilon.github.io/shiny.router/reference/router_ui.md)
  to allow dynamically passing of arguments. Now, its possible to pass
  routes in dynamic way with dynamic dots (`...`).
- Fixed the issue where the 404 page was not working when a user opens a
  non-valid link without going to a valid one first.

## shiny.router 0.3.0

CRAN release: 2023-03-02

- Added a new API that is compatible with Rhino. New functions
  `router_ui` and `router_server` are added. `make_router` is
  deprecated.

## shiny.router 0.2.3

CRAN release: 2022-07-01

- Fixed error with
  [`shiny.router::disable_bootstrap_on_bookmark()`](https://appsilon.github.io/shiny.router/reference/disable_bootstrap_on_bookmark.md)
  when used with development version of shiny by applying
  [`shiny::createWebDependency()`](https://rdrr.io/pkg/shiny/man/createWebDependency.html)
  before `renderDependencies()`.
- Fixed the issue displaying the main page bookmark on app start. Added
  update of hash path to be run once after default router page is being
  set-up.

## shiny.router 0.2.2

CRAN release: 2021-01-20

- Resolve
  [`htmltools::tagFunction()`](https://rstudio.github.io/htmltools/reference/tagFunction.html)
  returned by
  [`bootstrapLib()`](https://rdrr.io/pkg/shiny/man/bootstrapLib.html)
  with `resolveDependencies()` before rendering to achieve dynamic
  disabling of bootstrap.

## shiny.router 0.2.1

CRAN release: 2021-01-15

No changes.

## shiny.router 0.2.0

CRAN release: 2020-11-19

- Page state is now remembered. Forced all pages to be rendered during
  run time, but between page state is remembered and not rendered again.
  Use `router$ui()` instead of
  [`router_ui()`](https://appsilon.github.io/shiny.router/reference/router_ui.md)
  and `router$server(input, output, session)` instead of
  `router(input, output, session)`.
- Prevented re-rendering the whole page every time the URL was changed.
- Modify
  [`parse_url_path()`](https://appsilon.github.io/shiny.router/reference/parse_url_path.md)
  to support query strings following hashbang/path.
- Fixed the issue when the root page is running twice on initial run.
- Used relative paths when creating router links.
- Allowed passing a common value for each server callback.

## shiny.router 0.1.1

CRAN release: 2018-09-18

- First release
