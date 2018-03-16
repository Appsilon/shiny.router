# Constants

#' @export
PAGE_404_ADDRESS <- "404"

#' 404 page
#'
#' The page which appear when address of visited page is wrong.
#'
#' @param page shiny page style, eg. `div(h1("Not found"))``
#' @param message404 message to display at the 404 website
#'
#' @export
#' @examples
#' page404() # div(h1("Not found"))
#' page404(messege = "ABC") # div(h1("ABC"))
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
