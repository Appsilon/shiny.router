# Convenience function to retrieve just the "page" part of the input.

This corresponds to what might be called the "path" component of a URL,
except that we're using URLs with hashes before the path & query (e.g.:
http://www.example.com/#!/virtual/path?and=params)

## Usage

``` r
get_page(session = shiny::getDefaultReactiveDomain())
```

## Arguments

- session:

  The current Shiny Session

## Value

The current page in a length-1 character vector, or FALSE if the input
has no value.
