#' Parse url and build GET parameters list
#'
#' Extract info about url path and parameters that follow \code{?} sign.
#'
#' @param url_path character with link url
#' @return
#' list containing two objects: \itemize{
#'  \item path
#'  \item query, a list
#' }
#' @details
#' \code{parse_url_path} allows parsing paramaters lists from url. See more in examples.
#' @export
#' @examples
#' parse_url_path("#!/?a=1&b=foo")
#' parse_url_path("#!/?a=1&b[1]=foo&b[2]=bar")
#' parse_url_path("www.foo.bar?a=1&b[1]=foo&b[2]=bar")
parse_url_path <- function(url_path) {
  extracted_link <- extract_link_name(url_path)
  extracted_url_parts <- regmatches(extracted_link, regexpr("\\?", extracted_link), invert = TRUE)[[1]]
  path <- extracted_url_parts[1]

  if (length(extracted_url_parts) == 1) {
    query <- NULL
  } else {
    query <- shiny::parseQueryString(extracted_url_parts[2], nested = TRUE)
  }

  parsed <-  list(
    path = path,
    query = query
  )
  parsed
}
