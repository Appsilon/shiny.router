# 404 page

The page which appear when path is wrong.

## Usage

``` r
page404(page = NULL, message404 = NULL)
```

## Arguments

- page:

  shiny page style, e.g. `shiny::tags$div(h1("Not found"))`

- message404:

  message to display at the 404 website

## Examples

``` r
page404() # shiny::tags$div(h1("Not found"))
#> <div>
#>   <h1>Not found</h1>
#> </div>
page404(message404 = "ABC") # shiny::tags$div(h1("ABC"))
#> <div>
#>   <h1>ABC</h1>
#> </div>
```
