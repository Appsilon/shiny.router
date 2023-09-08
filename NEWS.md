# shiny.router (development version)

- Added a new tutorials menu

# shiny.router 0.3.1 (Latest)

- Added Rhino tutorial
- Added cross-domain Google Analytics tag
- Fixed the issue where the 404 page was not working when a non-valid page is opened as the first page
- Changed the dots (`...`) argument in `router_ui()` to allow dynamically passed arguments

# shiny.router 0.3.0

- Added Google Analytics tag
- Added a new demo
- Added a "Back to shiny.tools" button
- Added a new API that is compatible with Rhino

# shiny.router 0.2.3

- Resolved `shiny::bootstrapLib()` before rendering
- Fixed the issue displaying the main page bookmark on app start
- Fixed `disable_bootstrap_on_bookmark()` errors with the development version of Shiny
- Applied `shiny::createWebDependency()` before `renderDependencies()`

# shiny.router 0.2.1

- Added the possibility to suppress bootstrap on some bookmarks
- Allowed passing content for page404
- Allowed passing a common value for each server callback
- Used relative paths when creating router links
- Fixed the issue when the root page was running twice
- Added support for URLs with query strings preceding hashbang
- Stopped re-rendering the whole page every time the URL was changed
- Remembered page state
- Introduced a new version of the router

# shiny.router 0.2.0

- Semantic example now works when hosted in a subdirectory
- Fixed width for small screens (mobile)
- Allowed R code to change the current page
- Allowed R code to read query parameters from the page URL
- Allowed the page to start showing any of the routed URLs, rather than forcing a start on the "default" one
- Added convenience functions to check which page is currently loaded (in order to avoid performing intermediary calculations for pages that won't be displayed)
- Removed the `shinyjs` dependency due to changes in its license to AGPL
- Changed the `page.js` settings so that it uses `hashbang` URLs (aka "escaped fragment") and disabled the full page click-handler, as it wouldn't work correctly with the Shiny `DT` package
- Allowed passing GET parameters on the main page
- Allowed lists in GET parameters
- Switched to a 404 error page when a bad address is given
- Changed the URL hash extracting method to be compatible with IE
- Fixed the `escape_path()` function
- Added server-side callbacks
- Allowed the main page hash other than "/"
- Changed the core of the router from `page.js` to `updateQueryString`
- Added a debugging function `log_msg`
- Made it possible to catch GET parameters
- Changed the way of link declaration (by route_link)

# shiny.router 0.1.0

- First release
