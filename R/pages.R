# Constants

#' Default 404 page
#'
#' This is default 404 page.
#'
#' @export
PAGE_404_ROUTE <- "404"

#' 404 page
#'
#' The page which appear when path is wrong.
#'
#' @param page shiny page style, eg. `div(h1("Not found"))``
#' @param message404 message to display at the 404 website
#'
#' @export
#' @examples
#' page404() # div(h1("Not found"))
#' page404(message404 = "ABC") # div(h1("ABC"))
page404 <- function(page = NULL, message404 = NULL){
  if (is.null(page)) {
    if (is.null(message404)){
      return(shiny::div(shiny::h1("Not found")))
    } else {
      return(shiny::div(shiny::h1(message404)))
    }
  } else {
    return(page)
  }
}

#' Fix conflicts when some bookmark uses bootstrap
#'
#' This function dynamically removes bootstrap dependency when user opens specified bookmark.
#' It should be inserted in head of bootrstrap page.
#' @param bookmark Bookmark name on which bootstrap dependency should be suppressed.
#'
#' @importFrom htmltools renderDependencies
#' @export
disable_bootstrap_on_bookmark <- function(bookmark) {
  bootstrap_dependency <- renderDependencies(list(shiny:::bootstrapLib()), srcType = "href")
  shiny::tagList(
    shiny::suppressDependencies("bootstrap"),
    shiny::singleton(shiny::div(id = "bootstrap_dependency", bootstrap_dependency)),
    shiny::tags$script('
      var init_bootstrap_dependency = $("#bootstrap_dependency").html()
    '),
    shiny::tags$script(sprintf('
      window.addEventListener("hashchange", myFunction);
      function myFunction() {
        var dependency = init_bootstrap_dependency;
        if (window.location.hash == \"#!/%s\") {
          dependency = ""
        };
        $("#bootstrap_dependency").html(dependency);
      }
    ', bookmark))
  )
}
