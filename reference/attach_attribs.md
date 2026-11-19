# Attach 'router-hidden' class to single page UI content

Covered UI types are Shiny/htmltools tags or tag lists and html
templates. In case of tag list (`tagList`) and html template
(`htmlTemplate`) 'div' wrapper with 'router-hidden' class is added.

## Usage

``` r
attach_attribs(ui, path)
```

## Arguments

- ui:

  Single page UI content created with proper html tags or tag list.

- path:

  Single page path name. Attached to `data-path` attribute.
