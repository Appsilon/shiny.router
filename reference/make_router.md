# \[Deprecated\] Creates router.

Returned callback needs to be called within Shiny server code.

## Usage

``` r
make_router(default, ..., page_404 = page404())
```

## Arguments

- default:

  Main route to which all invalid routes should redirect.

- ...:

  All other routes defined with shiny.router::route function.

- page_404:

  Styling of page when wrong bookmark is open. See
  [page404](https://appsilon.github.io/shiny.router/reference/page404.md).

## Value

Shiny router callback that should be run in server code with Shiny input
and output lists.

## Examples

``` r
if (FALSE) { # \dontrun{
router <- make_router(
  route("/", root_page),
  route("/other", other_page),
  page_404 = page404(
    message404 = "Please check if you passed correct bookmark name!")
)
} # }
```
