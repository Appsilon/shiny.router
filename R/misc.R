#' Helper function to print out log messages into Shiny
#' using cat() and stderr(), as described on
#' https://shiny.rstudio.com/articles/debugging.html
#'
#' Because this can print a lot, it's silent unless
#' the shiny.router.debug option is set.
#'
#' @param ... All params get passed through to cat().
#' They're automatically wrapped in shiny::isolate(),
#' so you can print reactive values here without too
#' much worry.
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


#' Formats a URL fragment into a hashpath starting with "#!/"
#'
#' @param hashpath character with hash path
#'
#' @example
#' cleanup_hashpath("/abc") #  "#!/abc"
cleanup_hashpath <- function(hashpath) {
  hashpath = hashpath[1]

  # Already correctly formatted.
  if (substr(hashpath, 1, 3) == "#!/") {
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
