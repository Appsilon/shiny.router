# Parse url and build GET parameters list

Extract info about url path and parameters that follow `?` sign.

## Usage

``` r
parse_url_path(url_path)
```

## Arguments

- url_path:

  character with link url

## Value

list containing two objects:

- path

- query, a list

## Details

`parse_url_path` allows parsing parameters lists from url. See more in
examples.

Note that having query string appear before `#!` may cause browser to
refresh and thus reset Shiny session.

## Examples

``` r
parse_url_path("?a=1&b=foo")
#> $path
#> [1] ""
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> [1] "foo"
#> 
#> 
parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/")
#> $path
#> [1] ""
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/other_page")
#> $path
#> [1] "other_page"
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
parse_url_path("www.foo.bar/#!/other_page")
#> $path
#> [1] "other_page"
#> 
#> $query
#> NULL
#> 
parse_url_path("www.foo.bar?a=1&b[1]=foo&b[2]=bar/#!/other")
#> $path
#> [1] "other"
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
parse_url_path("#!/?a=1&b[1]=foo&b[2]=bar")
#> $path
#> [1] ""
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
parse_url_path("#!/other_page?a=1&b[1]=foo&b[2]=bar")
#> $path
#> [1] "other_page"
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
parse_url_path("www.foo.bar/#!/other?a=1&b[1]=foo&b[2]=bar")
#> $path
#> [1] "other"
#> 
#> $query
#> $query$a
#> [1] "1"
#> 
#> $query$b
#> $query$b$`1`
#> [1] "foo"
#> 
#> $query$b$`2`
#> [1] "bar"
#> 
#> 
#> 
```
