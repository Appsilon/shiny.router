# Create router pages server callback

Server part of the router.

## Usage

``` r
router_server(root_page = "/", env = parent.frame())
```

## Arguments

- root_page:

  Main page path.

- env:

  Environment (only for advanced usage).

## Value

Router pages server callback.

## Examples

``` r
if (FALSE) { # \dontrun{
  server <- function(input, output, session) {
    router_server(root_page = "/")
  }
} # }
```
