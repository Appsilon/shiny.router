# shiny.router 0.3.1

- Changed the dots (`...`) argument in `router_ui()` to allow dynamically passed arguments
- Fixed the issue where the 404 page was not working when a non-valid page is opened as the first page

# shiny.router 0.3.0

- Added a new API that is compatible with Rhino. New functions `router_ui` and `router_server` are added. `make_router` is deprecated.

# shiny.router 0.2.3

- Fixed error with `shiny.router::disable_bootstrap_on_bookmark()` when used with development version of shiny by applying `shiny::createWebDependency()` before `renderDependencies()`
- Fixed `disable_bootstrap_on_bookmark()` errors with the development version of Shiny
- Fixed the issue displaying the main page bookmark on app start

# shiny.router 0.2.2

- Resolved `shiny::bootstrapLib()` before rendering

# shiny.router 0.2.1

No changes.

# shiny.router 0.2.0

- Remembered page state
- Stopped re-rendering the whole page every time the URL was changed
- Added support for URLs with query strings preceding hashbang
- Fixed the issue when the root page was running twice
- Used relative paths when creating router links
- Allowed passing a common value for each server callback

# shiny.router 0.1.1

- First release
