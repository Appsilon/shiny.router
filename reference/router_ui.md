# Create router UI

Creates router UI in Shiny applications.

## Usage

``` r
router_ui(default, ..., page_404 = page404(), env = parent.frame())
```

## Arguments

- default:

  Main route to which all invalid routes should redirect.

- ...:

  All other routes defined with shiny.router::route function. It's
  possible to pass routes in dynamic way with dynamic dots. See
  [`dynamic-dots`](https://rlang.r-lib.org/reference/list2.html) and
  example below

- page_404:

  Styling of page when invalid route is open. See
  [page404](https://appsilon.github.io/shiny.router/reference/page404.md).

- env:

  Environment (only for advanced usage), makes it possible to use
  shiny.router inside shiny modules.

## Value

Application UI wrapped in a router.

## Details

If you are defining the router inside a shiny module, we assume that the
namespacing function defined in the UI is named as `ns`.

## Examples

``` r
if (FALSE) { # \dontrun{
  ui <- function() {
    router_ui(
      route("/", root_page(id = "root")),
      route("other", other_page(id = "other")),
      page_404 = page404(
        message404 = "Please check if you passed correct bookmark name!")
    )
  }
} # }
if (FALSE) { # \dontrun{
  # create the list of routes
  dynamic_routes <- list(
    route("other2", other_page(id = "other2")),
    route("other3", other_page(id = "other3"))
  )

  ui <- function() {
    router_ui(
      route("/", root_page(id = "root")),
      route("other", other_page(id = "other")),
      # then it's possible to inject a list of arguments into a function call using rlang::`!!!`
      !!!dynamic_routes,
      page_404 = page404(
        message404 = "Please check if you passed correct bookmark name!")
    )
  }
} # }
```
