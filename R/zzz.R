#' onLoad
#'
#' On package load it updates .i18_config reading yaml file from config.
#'
#' @param libname library name
#' @param pkgname package name
#'
.onLoad <- function(libname, pkgname){
  packageStartupMessage("shiny.router from version >= 0.2.0 introduced major
  changes to the API that are not compatible with the
  previous versions. Please check the docs, or examples
  to learn more: https://github.com/Appsilon/shiny.router")
}