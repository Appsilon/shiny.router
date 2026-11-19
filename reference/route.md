# Create single route configuration.

Create single route configuration.

## Usage

``` r
route(path, ui, server = NA)
```

## Arguments

- path:

  Website route.

- ui:

  Valid Shiny user interface.

- server:

  Function that is called as callback on server side \[deprecated\]

## Value

A route configuration.

## Examples

``` r
if (FALSE) { # \dontrun{
route("/", shiny::tags$div(shiny::tags$span("Hello world")))

route("main", shiny::tags$div(h1("Main page"), p("Lorem ipsum.")))
} # }
```
