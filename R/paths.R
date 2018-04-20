########################### Internal functions

#' Internal function that validates that path is defined in routes.
#'
#' @param routes A routes (list).
#' @param path A path.
#' @return Boolean value indicating if path is defined.
valid_path <- function(routes, path) {
  (path %in% names(routes))
}

#' Formats a URL fragment into a hashpath starting with "#!/"
#'
#' @param hashpath character with hash path
#'
#' @example
#' cleanup_hashpath("/abc") #  "#!/abc"
cleanup_hashpath <- function(hashpath) {
  hashpath = hashpath[1]
  # Already correctly formatted.
  if (substr(hashpath, 1, 3) == "#!/" | substr(hashpath, 1, 1) == "?") {
    return(hashpath)
  }

  # We remove any partial hashbang path marker from the start
  # of the string, then add back the full one.
  slicefrom <- 1
  while (substr(hashpath, slicefrom, slicefrom) %in% c("#", "!", "/"))
    slicefrom <- slicefrom + 1

  paste0(
    "#!/",
    substr(hashpath, slicefrom, nchar(hashpath))
  )
}

#' Extract link name
#'
#' Strips off the first 3 character, assuming that they are: "#!/".
#'
#' @param path character with link path
#' @return stripped link
#' @example
#' extract_link_name("#!/abc")
extract_link_name <- function(path) {
  sub("#!/", "", cleanup_hashpath(path))
}

#' Route link
#' Adds /#!/ prefix to link.
#'
#' @param path character with path
#' @return route link
#' @export
#' @examples
#' route_link("abc") # /#!/abc
route_link <- function(path) {
  paste0("/", cleanup_hashpath(path))
}

########################### To export

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
#' parse_url_path("?a=1&b=foo")
#' parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/")
#' parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/other_page")
#' parse_url_path("www.foo.bar/#!/other_page")
#' parse_url_path("www.foo.bar?a=1&b[1]=foo&b[2]=bar/#!/other")
parse_url_path <- function(url_path) {
  url_has_query <- grepl("?", url_path, fixed = TRUE)
  url_has_hash <- grepl("#", url_path, fixed = TRUE)
  extracted_url_parts <- sub("^/|/$", "", strsplit(url_path, split = "\\?|#!|#")[[1]])
  path <- ""

  if (url_has_query) {
    query <- extracted_url_parts[2]
    path <- if (url_has_hash) extracted_url_parts[3] else path
  } else {
    query <- NULL
    path <- if (url_has_hash) extracted_url_parts[2] else path
  }

  if (is.na(path)) {
    path <- ""
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

#' Convenience function to retrieve any params that were part of the requested
#' page. The param values returned come from "httr::parse_url()"
#' @param field If provided, retrieve only a param with this name. (Otherwise,
#' return all params)
#' @param session The Shiny session
#' @return The full list of params on the URL (if any), as a list. Or, the single
#' requested param (if present). Or NULL if there's no input, or no params.
#' @reactivesource
#' @export
get_query_param <- function(field = NULL, session = shiny::getDefaultReactiveDomain()) {
  log_msg("Trying to fetch field '", field)

  if (is.null(session$userData$shiny.router.page()$query)) {
    return(NULL)
  }

  if (missing(field)) {
    return(
      # Return a list of all the query params
      session$userData$shiny.router.page()$query
    )
  } else {
    return(session$userData$shiny.router.page()$query[[field]])
  }
}
