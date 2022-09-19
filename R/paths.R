########################### Internal functions

#' Internal function that validates that path is defined in routes.
#'
#' @param routes A routes (list).
#' @param path A path.
#' @return Boolean value indicating if path is defined.
#' @keywords internal
valid_path <- function(routes, path) {
  (path %in% names(routes))
}

#' Formats a URL fragment into a hashpath starting with "#!/"
#'
#' @param hashpath character with hash path
#' @return character with formatted hashpath
#' @keywords internal
cleanup_hashpath <- function(hashpath) {
  hashpath <- hashpath[1]
  # Already correctly formatted.
  if (substr(hashpath, 1, 3) == "#!/" || substr(hashpath, 1, 1) == "?") {
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
#' @keywords internal
extract_link_name <- function(path) {
  sub("#!/", "", cleanup_hashpath(path))
}

#' Route link
#'
#' Adds /#!/ prefix to link.
#'
#' @param path character with path
#' @return route link
#' @export
#' @examples
#' route_link("abc") # /#!/abc
route_link <- function(path) {
  paste0("./", cleanup_hashpath(path))
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
#'
#' Note that having query string appear before \code{#!} may cause browser to refresh
#' and thus reset Shiny session.
#' @export
#' @examples
#' parse_url_path("?a=1&b=foo")
#' parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/")
#' parse_url_path("?a=1&b[1]=foo&b[2]=bar/#!/other_page")
#' parse_url_path("www.foo.bar/#!/other_page")
#' parse_url_path("www.foo.bar?a=1&b[1]=foo&b[2]=bar/#!/other")
#' parse_url_path("#!/?a=1&b[1]=foo&b[2]=bar")
#' parse_url_path("#!/other_page?a=1&b[1]=foo&b[2]=bar")
#' parse_url_path("www.foo.bar/#!/other?a=1&b[1]=foo&b[2]=bar")
parse_url_path <- function(url_path) {
  url_query_pos <- gregexpr("?", url_path, fixed = TRUE)[[1]][1]
  url_hash_pos <- gregexpr("#", url_path, fixed = TRUE)[[1]][1]
  url_has_query <- url_query_pos[1] > -1
  url_has_hash <- url_hash_pos[1] > -1
  extracted_url_parts <- sub("^/|/$", "", strsplit(url_path, split = "\\?|#!|#")[[1]])
  path <- ""
  query <- NULL

  if (url_has_query && url_has_hash) {
    # Query string may appear before or after hash
    if (url_query_pos < url_hash_pos) {
      query <- extracted_url_parts[2]
      path <- extracted_url_parts[3]
    } else {
      query <- extracted_url_parts[3]
      path <- extracted_url_parts[2]
    }
  } else if (!url_has_query && url_has_hash) {
    path <- extracted_url_parts[2]
  } else {
    query <- extracted_url_parts[2]
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

#' Get Query Parameters
#'
#' Convenience function to retrieve any params that were part of the requested
#' page. The param values returned come from "httr::parse_url()"
#' @param field If provided, retrieve only a param with this name. (Otherwise,
#' return all params)
#' @param session The Shiny session
#' @return The full list of params on the URL (if any), as a list. Or, the single
#' requested param (if present). Or NULL if there's no input, or no params.
#'
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
