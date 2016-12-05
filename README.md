
<link href="http://fonts.googleapis.com/css?family=Lato:300,300italic|Inconsolata" rel="stylesheet" type="text/css"> <link href='docs/style.css' rel='stylesheet' type='text/css'>

shinyrouter
===========

A minimalistic router for your [Shiny](https://shiny.rstudio.com/) apps.

Now it's possible to recreate a state of your app, by providing a specific URL, like

    make_router(
      route("<your_app_url>/main",  mainPageShinyUI),
      route("<your_app_url>/other", otherPageShinyUI)
    )

<!--
TODO We would like to have a nice graphic explaning routing mechanism
-->
<!--
TODO [Live demo can be found here](http://appsilondatascience.com/demos/shinyrouter)
-->

Source code
-----------

This library source code can be found on [Appsilon Data Science's](http://appsilondatascience.com) Github: <br> <https://github.com/Appsilon/shinyrouter>

<a href="http://appsilondatascience.com"><img alt="Appsilon Data Science" src="https://cdn.rawgit.com/Appsilon/website-cdn/gh-pages/logo-white.png"/></a>

How to install?
---------------

**Note! This library is still in its infancy. Api might change in the future.**

At the moment it's possible to install this library through [devtools](https://github.com/hadley/devtools).

    devtools::install_github("Appsilon/shinyrouter")

To install [previous version](https://github.com/Appsilon/shinyrouter/blob/master/CHANGELOG.md) please you can run:

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

When developing this library we are using latest dependencies versions. So please make sure to update your R environment dependencies as well. But in case this library still doesn't work for you try to apply below suggestions:

1.  Up-to-date R language environment
2.  Installing specific dependent libraries versions
    -   magrittr `install.packages("magrittr", version='1.5')`
    -   shiny `install.packages("shiny", version='0.14.2.9001')`
    -   shinyjs `install.packages("shinyjs", version='0.8')`

3.  Missing semanticui dependency One of our examples uses one of our others libraries, so please make to install it as well, when running that example. Repository: [Semantic UI](https://github.com/Appsilon/semanticui)

Future enhacements
------------------

-   URL params handling
-   CRAN release
-   Maybe? Utilise <https://shiny.rstudio.com/articles/client-data.html> instead of Page.js

Appsilon Data Science
=====================

We Provide End to End Data Science Solutions

<a href="http://appsilondatascience.com">![Appsilon Data Science](https://cdn.rawgit.com/Appsilon/website-cdn/gh-pages/logo-white.png)</a>

<script>
document.write('<a href="https://github.com/you"><img style="position: absolute; margin: 0; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/38ef81f8aca64bb9a64448d0d70f1308ef5341ab/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"></a>')
</script>
