from shiny import App, ui
from shiny_router import  route_link, router_ui, route, router_server

tags = ui.tags

# This generates menu in user interface with links.
menu = tags.ul(
  tags.li(tags.a("Page", class_ = "item", href = route_link("/"))),
  tags.li(tags.a("Other page", class_ = "item", href = route_link("other"))),
  tags.li(tags.a("A third page", class_ = "item", href = route_link("third")))
)

# This creates UI for each page.
def page(title, content):
  return tags.div(
    menu,
    tags.h1(title),
    tags.p(content),
  )

# Both sample pages.
root_page = page("Home page", "Welcome on sample routing page!")
other_page = page("Some other page", "Lorem ipsum dolor sit amet.")
third_page = tags.div(menu, tags.h3("Third Page"))

# Make output for our router in main UI of Shiny app.
app_ui = ui.page_fluid(
  router_ui(
    route("/", root_page),
    route("other", other_page),
    route("third", third_page)
  )
)

# Plug router into Shiny server.
def server(input, output, session):
  router_server(input, output, session)

app = App(app_ui, server)