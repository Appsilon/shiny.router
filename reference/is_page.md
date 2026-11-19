# Is page

Tell the reactive chain to halt if we're not on the specified page.
Useful for making sure we don't waste cycles re-rendering the UI for
pages that are not currently displayed.

## Usage

``` r
is_page(page, session = shiny::getDefaultReactiveDomain(), ...)
```

## Arguments

- page:

  The page to display. Should match one of the paths sent to the

- session:

  Shiny session

- ...:

  Other parameters are sent through to
  [`shiny::req()`](https://rdrr.io/pkg/shiny/man/req.html) router.
