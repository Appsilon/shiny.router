# Get Query Parameters

Convenience function to retrieve any params that were part of the
requested page. The param values returned come from "httr::parse_url()"

## Usage

``` r
get_query_param(field = NULL, session = shiny::getDefaultReactiveDomain())
```

## Arguments

- field:

  If provided, retrieve only a param with this name. (Otherwise, return
  all params)

- session:

  The Shiny session

## Value

The full list of params on the URL (if any), as a list. Or, the single
requested param (if present). Or NULL if there's no input, or no params.
