# Change the currently displayed page.

Works by sending a message up to our reactive input binding on the
client side, which tells page.js to update the window URL accordingly,
then tells client side shiny that our reactive input binding has
changed, then that comes back down to our router callback function and
all other observers watching
[`get_page()`](https://appsilon.github.io/shiny.router/reference/get_page.md)
or similar.

## Usage

``` r
change_page(page, session = shiny::getDefaultReactiveDomain(), mode = "push")
```

## Arguments

- page:

  The new URL to go to. Should just be the path component of the URL,
  with optional query, e.g. "/learner?id=%d"

- session:

  The current Shiny session.

- mode:

  ("replace" or "push") whether to replace current history or push a new
  one. More in
  [`shiny::updateQueryString`](https://rdrr.io/pkg/shiny/man/updateQueryString.html).
