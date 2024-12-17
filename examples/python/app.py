from shiny import App, ui, render, reactive
from shiny_router import route_link, router_ui, route, router_server, get_query_param

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
third_page = tags.div(menu, tags.h3("Third Page"), ui.input_action_button(id = "click", label = "Click me"))

# Make output for our router in main UI of Shiny app.
app_ui = ui.page_fluid(
  ui.output_ui("param"),
  router_ui(
    route("/", root_page),
    route("other", other_page),
    route("third", third_page)
  )
)

# Plug router into Shiny server.
def server(input, output, session):
  router_server(input, output, session)

  @render.ui
  def param():
    query = get_query_param(session = session)
    id = get_query_param("id", session = session)
    return ui.TagList(
      ui.p("No query" if not query else str(query)),
      ui.p("No id" if not id else str(id)),
    )

  @reactive.effect
  async def redirect():
    counter = input.click()
    if counter:
      await session.send_custom_message("_shiny_router_change_url", {"url": "elo"})


app = App(app_ui, server)