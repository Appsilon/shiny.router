from shiny import ui, reactive, session
from htmltools import HTMLDependency
from pathlib import PurePath
from urllib.parse import urlparse, parse_qs

log_msg = print
PAGE_404_ROUTE = "404"

def get_query_param(field = None, session = session.get_current_session()):
    page_details = session.input.shiny_router_page()

    if field:
        if field in page_details["query"]:
            return page_details["query"][field][0]
        else:
            return None

    return page_details["query"]

def page404(page=None, message404=None):
    if page is None:
        # Return a default "Not found" message or a custom 404 message
        return ui.div(
            ui.h1(message404 if message404 else "Not found")
        )
    else:
        # Return the provided page if available
        return page


def cleanup_hashpath(hashpath):
    # Check if already formatted correctly
    if hashpath.startswith("#!/"):
        return hashpath

    # Remove any leading # or / characters
    hashpath = hashpath.lstrip("#/")

    # Add the correct hashbang format
    return f"#!/{hashpath}"

def create_router_callback(root, routes=None):
    def router_callback(input, output, session=None, **kwargs):
        log_msg("Creating current_page reactive...")

        input.shiny_router_page = reactive.value(dict(
            path = root,
            query = {},
            unparsed = root
        ))

        @reactive.effect
        @reactive.event(input._clientdata_url_hash)
        def _():
            requested_path = input._clientdata_url_hash()
            parsed_url = urlparse(requested_path)
            fragment_path = urlparse(parsed_url.fragment)
            clean_path = fragment_path.path.lstrip("!").lstrip("/")
            query_params = parse_qs(fragment_path.query)

            print("Path:", clean_path)
            print("Query Parameters:", query_params)

            input.shiny_router_page.set(dict(
                path = clean_path,
                query = query_params,
                unparsed = requested_path, 
            ))

        @reactive.effect
        @reactive.event(input.shiny_router_page)
        async def _():
            page_path = input.shiny_router_page()
            log_msg("shiny.router main output. path: ", page_path["path"])
            await session.send_custom_message("switch-ui", page_path)
        
    return router_callback


def router_server(input, output, session, root_page="/"):
    # Create the router callback
    router = create_router_callback(root_page)

    # Invoke the router with the necessary environment inputs
    router(input, output, session)


def route_link(path):
    return f"./{cleanup_hashpath(path)}"

def attach_attribs(ui_element, path):
    if isinstance(ui_element, ui.Tag):
        ui_element.attrs['data-path'] = path
        ui_element.attrs['class'] = f"router router-hidden {ui_element.attrs.get('class', '')}"
    else:
        container = ui.div(*ui_element)
        container.attrs['data-path'] = path
        container.attrs['class'] = "router router-hidden"
        ui_element = container
    return ui_element

def callback_mapping(path, ui, server=None):
    if not callable(server):
        server = lambda input, output, session, *args: None
    # R version does wrapping here, we're trying to skip this in python.
    # At least in the initial PoC.
    ui = attach_attribs(ui, path)
    return {'ui': ui, 'server': server}

def route(path, ui, server=None):
    if server is not None:
        print("Warning: 'server' argument in 'route' is deprecated.")
    return {"path": path, "logic": callback_mapping(path, ui, server)}

def router_ui(default, *args, page_404=None):
    routes = {**default, **{arg: callback_mapping(arg, ui) for arg, ui in args}}
    root = list(default.keys())[0]
    if '404' not in routes:
        routes['404'] = route('404', page_404)
    return {'root': root, 'routes': routes}


def router_ui_internal(router):
    # Define paths to JavaScript and CSS files
    js_file = "shiny.router.js"
    css_file = "shiny.router.css"

    pkg_dependency = HTMLDependency("shiny_router", "0.0.1",
        source={
            "package": "shiny_router",
            "subdir": str(PurePath(__file__).parent / "www"),
        },
        script={"src": js_file, "type": "module"},
        stylesheet={"href": css_file}
    )

    # Create UI elements
    return ui.TagList(
        pkg_dependency,
        ui.div(
            [route["logic"]["ui"] for route in router["routes"]],
            id="router-page-wrapper"
        )
    )

def router_ui(default, *args, page_404=None, env=None):
    # Initialize page_404 if not provided
    if page_404 is None:
        page_404 = page404()

    # Collect dynamic routes and ensure they are unnamed
    paths = list(args)

    # Set up routes by merging default and additional paths
    routes = [default] + paths
    root = default.get('path') if isinstance(default, dict) else default

    # Add 404 route if not already defined
    if PAGE_404_ROUTE not in [route.get('path') for route in routes]:
        routes.append(route(PAGE_404_ROUTE, page_404))

    router = {"root": root, "routes": routes}

    # Determine input ID for routes
    routes_input_id = "routes"
    if env and 'ns' in env:
        routes_input_id = env['ns'](routes_input_id)

    # Prepare JavaScript to set routes dynamically
    routes_names = ", ".join([f"'{route['path']}'" for route in routes if 'path' in route])

    # Create HTML and script tags (similar to Shiny's tagList)
    html_output = ui.TagList(
        ui.tags.script(f"$(document).on('shiny:connected', function() {{Shiny.setInputValue('{routes_input_id}', [{routes_names}]);}});"),
        router_ui_internal(router)
    )
    
    # Return HTML list for the UI (modify as per your web framework if needed)
    return html_output
