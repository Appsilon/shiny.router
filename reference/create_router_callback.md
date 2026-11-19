# Internal function creating a router callback function. One need to call router callback with Shiny input and output in server code.

Internal function creating a router callback function. One need to call
router callback with Shiny input and output in server code.

## Usage

``` r
create_router_callback(root, routes = NULL)
```

## Arguments

- root:

  Main route to which all invalid routes should redirect.

- routes:

  A routes (list).

## Value

Router callback.
