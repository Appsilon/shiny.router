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

#' Chack hashpath
#'
#' Validates if path starts from hash #!/
#'
#' @param hashpath character with hash path
#'
#' @return TRUE if hash path starts with "#!/"
#'
#' @examples
#' check_hashpath("#!/abc")
check_hashpath <- function(hashpath){
  substr(hashpath, 1, 3) == "#!/"
}

#' Cleanup Hashpath
#'
#' Formats a URL fragment into a hashpath starting with "#!/"
#'
#' @param hashpath character with hash path
cleanup_hashpath <- function(hashpath) {
  hashpath = hashpath[1]

  # Already correctly formatted.
  if (check_hashpath(hashpath)) {
    return(hashpath)
  }

  # We remove any partial hashbang path morker from the start
  # of the string, then add back the full one.
  slicefrom <- 1
  if (substr(hashpath, slicefrom, slicefrom) == "#") {
    slicefrom <- slicefrom + 1
  }
  if (substr(hashpath, slicefrom, slicefrom) == "!") {
    slicefrom <- slicefrom + 1
  }
  if (substr(hashpath, slicefrom, slicefrom) == "/") {
    slicefrom <- slicefrom + 1
  }

  paste0(
    "#!/",
    substr(hashpath, slicefrom, nchar(hashpath))
  )
}
