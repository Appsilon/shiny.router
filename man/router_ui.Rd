% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/router.R
\name{router_ui}
\alias{router_ui}
\title{Create router UI}
\usage{
router_ui(default, ..., page_404 = page404(), env = parent.frame())
}
\arguments{
\item{default}{Main route to which all invalid routes should redirect.}

\item{...}{All other routes defined with shiny.router::route function.
It's possible to pass routes in dynamic way with dynamic dots.
See \code{\link[rlang:dots_list]{dynamic-dots}} and example below}

\item{page_404}{Styling of page when invalid route is open. See \link{page404}.}

\item{env}{Environment (only for advanced usage), makes it possible to use shiny.router inside
shiny modules.}
}
\value{
Application UI wrapped in a router.
}
\description{
Creates router UI in Shiny applications.
}
\details{
If you are defining the router inside a shiny module,
  we assume that the namespacing function defined in the UI is named as \code{ns}.
}
\examples{
\dontrun{
  ui <- function() {
    router_ui(
      route("/", root_page(id = "root")),
      route("other", other_page(id = "other")),
      page_404 = page404(
        message404 = "Please check if you passed correct bookmark name!")
    )
  }
}
\dontrun{
  # create the list of routes
  dynamic_routes <- list(
    route("other2", other_page(id = "other2")),
    route("other3", other_page(id = "other3"))
  )

  ui <- function() {
    router_ui(
      route("/", root_page(id = "root")),
      route("other", other_page(id = "other")),
      # then it's possible to inject a list of arguments into a function call using rlang::`!!!`
      !!!dynamic_routes,
      page_404 = page404(
        message404 = "Please check if you passed correct bookmark name!")
    )
  }
}
}
