# Fix conflicts when some bookmark uses bootstrap

This function dynamically removes bootstrap dependency when user opens
specified bookmark. It should be inserted in head of bootstrap page.

## Usage

``` r
disable_bootstrap_on_bookmark(bookmark)
```

## Arguments

- bookmark:

  Bookmark name on which bootstrap dependency should be suppressed.
