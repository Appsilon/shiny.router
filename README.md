
<link href="http://fonts.googleapis.com/css?family=Lato:300,300italic|Inconsolata" rel="stylesheet" type="text/css"> <link href='docs/style.css' rel='stylesheet' type='text/css'>

shinyrouter
===========

A minimalistic router for your [Shiny](https://shiny.rstudio.com/) apps.

 
-

Now it's possible to recreate a state of your app, by providing a specific URL, like

    make_router(
      route("<your_app_url>/main",  mainPageShinyUI),
      route("<your_app_url>/other", otherPageShinyUI)
    )

<!--
TODO We would like to have a nice graphic explaning routing mechanism
-->
[Live demo can be found here](http://appsilondatascience.com/demos/shinyrouter)

Source code
-----------

This library source code can be found on Appsilon's Github: <br> <https://github.com/Appsilon/shinyrouter>

How to install?
---------------

**Note! This library is still in its infancy. Api might change in the future.**

At the moment it's possible to install this library through [devtools](https://github.com/hadley/devtools).

    devtools::install_github("Appsilon/shinyrouter")

To install [previous version](https://github.com/Appsilon/shinyrouter/CHANGELOG.md) please you can run:

    devtools::install_github("Appsilon/shinyrouter", ref = "0.1.0")

Example
-------

All the exmaples can be found in /examples directory. Here's the basic usage:

    router <- make_router(
      route("/", root_page),
      route("/other", other_page)
    )

    ui <- shinyUI(semanticPage(
      title = "Router demo",
      router_ui()
    ))

    server <- shinyServer(function(input, output) {
      router(input, output)
    })

    shinyApp(ui, server)

Troubleshooting
---------------

When developing this library we are using latest dependencies versions. So please make sure to update your R environment dependencies as well. But in case this library still doesn't work for you try to apply below suggestions: 1. Up-to-date R language environment 2. Installing specific dependent libraries versions --\* magrittr

    install.packages("magrittr", version='1.5')

--\* shiny

    install.packages("shiny", version='0.14.2.9001')

--\* shinyjs

    install.packages("shinyjs", version='0.8')

1.  Missing semanticui dependency One of our examples uses one of our others libraries, so please make to install it as well, when running that example. Repository: [Semantic UI](https://github.com/Appsilon/semanticui)

Future enhacements
------------------

-   URL params handling
-   CRAN release
-   Maybe? Utilise <https://shiny.rstudio.com/articles/client-data.html> instead of Page.js
