
<link href="http://fonts.googleapis.com/css?family=Lato:300,300italic|Inconsolata" rel="stylesheet" type="text/css"> <link href='docs/style.css' rel='stylesheet' type='text/css'>

shiny.router
============

A minimalistic router for your [Shiny](https://shiny.rstudio.com/) apps.

Now it's possible to recreate a state of your app, by providing a specific URL, like:

    make_router(
      route("<your_app_url>/main",  mainPageShinyUI),
      route("<your_app_url>/other", otherPageShinyUI)
    )

<!--
TODO We would like to have a nice graphic explaning routing mechanism
-->
<p style="text-align: center; font-size: x-large;">
<a href="http://demo.appsilondatascience.com/shiny.router/">Live demo</a>
</p>

Source code
-----------

This library source code can be found on [Appsilon Data Science's](http://appsilondatascience.com) Github: <br> <https://github.com/Appsilon/shiny.router>

<script>
document.write('<div class="logo"><a href="http://appsilondatascience.com"><img alt="Appsilon Data Science" src="https://cdn.rawgit.com/Appsilon/website-cdn/gh-pages/logo-white.png"/></a></div>')
</script>
How to install?
---------------

**Note! This library is still in its infancy. Api might change in the future.**

At the moment it's possible to install this library through [devtools](https://github.com/hadley/devtools).

    devtools::install_github("Appsilon/shiny.router")

To install [previous version](https://github.com/Appsilon/shiny.router/blob/master/CHANGELOG.md) you can run:

    devtools::install_github("Appsilon/shiny.router", ref = "0.1.0")

Example
-------

Visit /examples directory for some complete samples. Here's the basic usage:

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

We used the latest versions of dependencies for this library, so please update your R environment before installation.

However, if you encounter any problems, try the following:

1.  Up-to-date R language environment
2.  Installing specific dependent libraries versions
    -   magrittr

            install.packages("magrittr", version='1.5') 

    -   shiny

            install.packages("shiny", version='0.14.2.9001')

    -   shinyjs

            install.packages("shinyjs", version='0.8')

3.  Missing semanticui dependency - one of our examples uses one of our others libraries, so please install it as well, when running that example. Repository: [semanticui](https://github.com/Appsilon/semanticui)

Future enhacements
------------------

-   URL params handling
-   CRAN release
-   consider utilising <https://shiny.rstudio.com/articles/client-data.html> instead of Page.js

Appsilon Data Science
=====================

<script>
document.write('<div class="subheader"> We Provide End-to-End Data Science Solutions </div>  <div class="logo"><a href="http://appsilondatascience.com"><img alt="Appsilon Data Science" src="https://cdn.rawgit.com/Appsilon/website-cdn/gh-pages/logo-white.png" /></a></div>');
</script>
Get in touch [dev@appsilondatascience.com](dev@appsilondatascience.com)

<script>
document.write('<a href="https://github.com/Appsilon/shiny.router"><img style="position: absolute; margin: 0; top: 0; right: 0; border: 0;" src="https://camo.githubusercontent.com/38ef81f8aca64bb9a64448d0d70f1308ef5341ab/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6461726b626c75655f3132313632312e706e67" alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png"></a>')
</script>
