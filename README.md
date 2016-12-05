shinyrouter
===========
A minimalistic router for your [Shiny](https://shiny.rstudio.com/) apps. Now it's possible to recreate a state of your app, by providing a specific URL, like 
```
make_router(
  route("<your_app_url>/main",  mainPageShinyUI),
  route("<your_app_url>/other", otherPageShinyUI)
)
```
<!--
TODO We would like to have a nice graphic explaning routing mechanism
-->
[Live demo can be found here](http://appsilondatascience.com/demos/shinyrouter)

How to install?
---------------
**Note! This library is currently in its infancy. Api might change in the future.**
At the moment it's possible to install this library through [devtools](https://github.com/hadley/devtools).
```
devtools::install_github("Appsilon/shinyrouter")
```

## [Previous versions](https://github.com/Appsilon/shinyrouter/CHANGELOG.md)
To install previous version please you can run:
```
devtools::install_github("Appsilon/shinyrouter", ref = "v0.1.0")
```

Example
-------
All the exmaples can be found in /examples directory.
Here's the basic usage:
```
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
```

Trouble shoutting
-----------------

How to contribute?
------------------

Future enhacements
------------------

<!--
1.  What is shinyrouter?
	- What it is?
	- Why it was created? All web frameworks have some routing mechanism
	- Provided by Appsilon
2.  How to install?
	1.  Note! Uder heavy development. Api might change.
	2.  Current version
	3.  Legacy versions
3.  Example
	1.  Routing mechanics
	2.  Link to demu -> goes through appsilon demo apps
4.  Trouble shoutting
	1.  Install specific dependencies version
		1.  Dependencies
			1.  magrittr -> recomended version
			2.  shiny -> recomended version
			3.  shinyjs -> recomended version
			4.  pageJS -> recommended version 1.7.1
5.  How to contribute?
	1.  Bower dependency install to bump page.js version
6.  Future enhacements
	1.  Params handling
	2.  CRAN release
  3. https://shiny.rstudio.com/articles/client-data.html
-->
