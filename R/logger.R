#' Helper function to print out log messages into Shiny
#' using \code{cat()} and \code{stderr()}, as described on
#' https://shiny.rstudio.com/articles/debugging.html
#'
#' Because this can print a lot, it's silent unless
#' the shiny.router.debug option is set.
#'
#' @param ... All params get passed through to cat().
#' They're automatically wrapped in shiny::isolate(),
#' so you can print reactive values here without too
#' much worry.
#' @keywords internal
log_msg <- function(...) {
  if (getOption("shiny.router.debug", default = FALSE)) {
    shiny::isolate(
      do.call(
        "cat",
        alist(
          file = stderr(),
          ...
        )
      )
    )
    cat("\n")
  }
}
