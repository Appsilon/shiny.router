from shiny_router import route_link

def test_route_link():
    assert route_link("/") == "./#!/"
    assert route_link("abc") == "./#!/abc"
    assert route_link("#/xyzq") == "./#!/xyzq"