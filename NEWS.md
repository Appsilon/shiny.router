# shiny.router (development version)

- Changed the dots (`...`) argument in `router_ui()` to allow dynamically passed arguments
- Fixed the issue where the 404 page was not working when a non-valid page is opened as the first page

# shiny.router 0.3.0

- Added a new API that is compatible with Rhino
- `router_ui` and `router_server` replaced `make_router`
- `router_ui` should be applied inside the UI function (not outside, like `make_router`) and thanks to that, can utilize ns if used in a Rhino app
- `router_server` adds all required server components (mostly observeEvents) to the server part of the application
- Marked `make_router` as deprecated, it is not removed

# shiny.router 0.2.3

- Applied `shiny::createWebDependency()` before `renderDependencies()`
- Fixed `disable_bootstrap_on_bookmark()` errors with the development version of Shiny
- Fixed the issue displaying the main page bookmark on app start

# shiny.router 0.2.2

- Resolved `shiny::bootstrapLib()` before rendering

# shiny.router 0.2.1

No changes.

# shiny.router 0.2.0

- Introduced a new version of the router
- Remembered page state
- Stopped re-rendering the whole page every time the URL was changed
- Added support for URLs with query strings preceding hashbang
- Fixed the issue when the root page was running twice
- Used relative paths when creating router links
- Allowed passing a common value for each server callback

# shiny.router 0.1.1

- First release
