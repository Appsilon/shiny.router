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
  extracted_link <- cleanup_hashpath(url_path)
  url_has_query <- grepl("?", extracted_link, fixed = TRUE)
  extracted_url_parts <- strsplit(extracted_link, split = "\\?|#")[[1]]

  if (length(extracted_url_parts) == 0) {
    path <-  ""
    query = NULL
  } else if (url_has_query && length(extracted_url_parts) == 3) {
    path <- substr(extracted_url_parts[3], 3, nchar(extracted_url_parts[3]))
    query <- extracted_url_parts[2]
  } else if (url_has_query && length(extracted_url_parts) != 3) {
    path <- ""
    query <- extracted_url_parts[2]
  } else if (length(extracted_url_parts) == 1) {
    path <- extracted_url_parts[1]
    query <- NULL
  } else {
    path <- substr(extracted_url_parts[2], 3, nchar(extracted_url_parts[2]))
    query <- NULL
  }

  if (!is.null(query)) {
    query <- shiny::parseQueryString(query, nested = TRUE)
  }

  parsed <-  list(
    path = path,
    query = query
  )
  parsed
}
