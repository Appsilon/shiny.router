#' On Load
#'
#' On package load it updates .i18_config reading yaml file from config.
#'
#' @param libname library name
#' @param pkgname package name
#'
#' @keywords internal
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("shiny.router from version > 0.2.3 introduced major
  changes to the API. Old API is still working but has been marked as deprecated.
  Please check the docs, or examples to learn more: https://github.com/Appsilon/shiny.router")
}
