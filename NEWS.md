# shiny.router (development version)

- New tutorials menu

# shiny.router 0.3.1 (Latest)

- Added Rhino tutorial
- Added second Google Analytics tag
- Fix 404 page not working when a non-valid page is opened as the first page
- Change dots `...` argument in `router_ui()` to allow dynamically passed arguments

# shiny.router 0.3.0

- Add Google Analytics tag
- Add a new demo
- Add Back to shiny.tools button
- Introduce new API for Rhino compatibility

# shiny.router 0.2.3

- Resolve `shiny::bootstrapLib()` before rendering
- Fix displaying main page bookmark on app start
- Fix `disable_bootstrap_on_bookmark()` errors with development version of Shiny
- Apply `shiny::createWebDependency()` before `renderDependencies()`

# shiny.router 0.2.1

- Semantic example works when hosted in sub directory
- Width fix for small screens (mobile)
- Let R code change the current page
- Let R code read query parameters from the page URL
- Let the page start showing any of the routed URLs, rather than forcing a start on the "default" one
- Convenience functions to check which page is currently loaded (in order to avoid performing intermediary calculations for pages that won't be displayed.)
- Removing the `shinyjs` dependency, because its license has changed to AGPL
- Change the `page.js` settings so that it uses `hashbang` URLs (aka "escaped fragment"), and disabled the full page click-handler, because that wouldn't work correctly with the Shiny `DT` package
- Allow passing GET parameters on the main page
- Allow lists in GET
- Switches to 404 when bad address given
- Change URL hash extracting to be compatible with IE
- Fix file structure
- Hash and query order change
- Fix `escape_path()`
- Servers side callbacks
- Allow main page hash other than "/"
- Possibility to suppress bootstrap on some bookmarks
- Allow passing content for page404
- Allow passing common value for each server callback
- Use relative path when creating router link
- Fix issue when root page running twice
- Add support for URLs with query strings proceeding hashbang
- Stop re-rendering the whole page every time URL is changed
- Remember page state
- New version of router

# shiny.router 0.1.0

- First release
