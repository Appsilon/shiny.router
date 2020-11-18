<a href = "https://appsilon.com/careers/" target="_blank"><img src="http://d2v95fjda94ghc.cloudfront.net/hiring.png" alt="We are hiring!"/></a>


<img src="man/figures/shiny.router.png" align="right" alt="" width="150" />

shiny.router
============

<!-- badges: start -->
![R-CMD-check](https://github.com/Appsilon/shiny.router/workflows/R-CMD-check/badge.svg)
[![codecov](https://codecov.io/gh/Appsilon/shiny.router/branch/master/graph/badge.svg)](https://codecov.io/gh/Appsilon/shiny.router)
[![cranlogs](https://cranlogs.r-pkg.org/badges/shiny.router)](https://CRAN.R-project.org/package=shiny.router)
[![total](https://cranlogs.r-pkg.org/badges/grand-total/shiny.router)](https://CRAN.R-project.org/package=shiny.router)
<!-- badges: end -->

A minimalistic router for your [Shiny](https://shiny.rstudio.com/) apps.

Now it's possible to recreate a state of your app, by providing a specific URL, like:

```r
  make_router(
    route("<your_app_url>/main",  mainPageShinyUI),
    route("<your_app_url>/other", otherPageShinyUI)
  )
```

<!-- TODO We would like to have a nice graphic explaning routing mechanism -->

Basic tutorial article is available on [Appsilon's blog](https://appsilon.com/shiny-router-package/).


<h4><a href="https://demo.appsilon.ai/apps/router2/" target="_blank">Live demo</a> </h4>


Source code
-----------

This library source code can be found on [Appsilon's](https://appsilon.com) Github: https://github.com/Appsilon/shiny.router

How to install?
---------------

It's possible to install this library through CRAN

```r
  install.packages("shiny.router")
```

The most recent version you can get from this repo using [remotes](https://github.com/r-lib/remotes).

```r
  remotes::install_github("Appsilon/shiny.router")
```

To install [previous version](https://github.com/Appsilon/shiny.router/blob/master/CHANGELOG.md) you can run:

```r
  remotes::install_github("Appsilon/shiny.router", ref = "0.1.0")
```

Example
-------

Visit [examples](https://github.com/Appsilon/shiny.router/tree/master/examples) directory for some complete samples. Here's the basic usage:

```r
library(shiny)
library(shiny.router)

root_page <- div(h2("Root page"))
other_page <- div(h3("Other page"))

router <- make_router(
  route("/", root_page),
  route("other", other_page)
)

ui <- fluidPage(
  title = "Router demo",
  router$ui
)

server <- function(input, output, session) {
  router$server(input, output, session)
}

shinyApp(ui, server)
```

How to contribute?
------------------

If you want to contribute to this project please submit a regular PR, once you're done with new feature or bug fix.

Reporting a bug is also helpful - please use github issues and describe your problem as detailed as possible.

**Changes in documentation**

Documentation is rendered with `pkgdown`. Just run `pkgdown::build_site()` after editing documentation or `README.md`.

Troubleshooting
---------------

We used the latest versions of dependencies for this library, so please update your R environment before installation.

However, if you encounter any problems, try the following:

1.  Up-to-date R language environment
2.  Installing specific dependent libraries versions
    -   magrittr
            ```r
            install.packages("magrittr", version='1.5')
            ```

    -   shiny
            ```r
            install.packages("shiny", version='0.14.2.9001')
            ```

3.  Missing `shiny.semantic` dependency - one of our examples uses one of our others libraries, so please install it as well, when running that example. Repository: [shiny.semantic](https://github.com/Appsilon/shiny.semantic).

Future enhacements
------------------

- customize loading full session or just visible part

Appsilon
========

<img src="https://avatars0.githubusercontent.com/u/6096772" align="right" alt="" width="6%" />

Appsilon is the **Full Service Certified RStudio Partner**. Learn more
at [appsilon.com](https://appsilon.com).

Get in touch [dev@appsilon.com](dev@appsilon.com)
