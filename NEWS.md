# shiny.router 0.3.1

- Changed the dots (`...`) argument in `router_ui()` to allow dynamically passing of arguments.
- Fixed the issue where the 404 page was not working when a user opens a non-valid link without going to a valid one first.

# shiny.router 0.3.0

- Added a new API that is compatible with Rhino. New functions `router_ui` and `router_server` are added. `make_router` is deprecated.

# shiny.router 0.2.3

- Fixed error with `shiny.router::disable_bootstrap_on_bookmark()` when used with development version of shiny by applying `shiny::createWebDependency()` before `renderDependencies()`.
- Fixed the issue displaying the main page bookmark on app start. Fixed issue of hash path not updated when opening default page. Added update of hash path to be run once after default router page is being set-up.

# shiny.router 0.2.2

- Resolve `htmltools::tagFunction()` returned by `bootstrapLib()` with `resolveDependencies()` before rendering to achieve dynamic disabling of bootstrap.

# shiny.router 0.2.1

No changes.

# shiny.router 0.2.0

- Page state is now remembered. Forced all pages to be rendered during run time, but between page state is remembered and not rendered again. Use `router$ui()` instead of `router_ui()` and `router$server(input, output, session)` instead of `router(input, output, session)`.
- Prevented re-rendering the whole page every time the URL was changed.
- Modify `parse_url_path()` to support query strings following hashbang/path.
- Fixed the issue when the root page is running twice on initial run.
- Used relative paths when creating router links.
- Allowed passing a common value for each server callback.

# shiny.router 0.1.1

- First release
