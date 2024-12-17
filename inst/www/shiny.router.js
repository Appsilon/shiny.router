/**
 * A good old-fashioned ES5 fake module.
 * See https://medium.com/@crohacz_86666/basics-of-modular-javascript-2395c82dd93a
 */
window.shinyrouter = function() {

    // When you use the "push" mode in shiny::updateQueryString()
    // method, it triggers a "hashchange" event, and a Shiny event handler
    // uses that to detect the change and update the value you get from
    // shiny::getUrlHash().
    //
    // But, as noted in the docs for shiny::getUrlHash(), doing it with
    // "replace" mode doesn't trigger the event, and so the value in
    // shiny::getUrlHash() doesn't update either.
    //
    // As a hacky workaround, this code wraps window.history.replaceState()
    // (which is what Shiny ultimately uses) with a function that triggers
    // a hashchange event if the hash is changing.
    var origReplaceState = window.history.replaceState;
    window.history.replaceState = function() {
        var newhash = false;
        var oldhash = window.location.hash;
        if (arguments.length >= 3 && typeof arguments[2] === 'string') {
            newhash = ""; // this part extracts url hash from url with pure JS
            var path_params_and_anchor = arguments[2];
            if (path_params_and_anchor.indexOf("#") >= 0) {
              newhash = path_params_and_anchor.substring(path_params_and_anchor.indexOf("#"), path_params_and_anchor.length);
            }
        }

        var result = origReplaceState.apply(this, arguments);

        if (newhash !== oldhash) {
            $(document).trigger("hashchange", newhash);
        }
    };

    return {
        // If we wanted shiny.router to have a JS API, we could return elements
        // here in order to "export" them.
    };
}();

const switchUI = function(message) {
  // In Shiny for R message can be string and path is send as string.
  // In Shiny for Python meesage has to be an object. Path is send as field.
  const path = typeof message === "string" ? message : message?.path; 

  var routes = $("#router-page-wrapper").find(".router");
  var active_route = routes.filter(function() {
    return $(this).data("path") == path;
  });
  routes.addClass('router-hidden');
  active_route.removeClass('router-hidden');
};

Shiny.addCustomMessageHandler("switch-ui", switchUI);

const change_url = function(message) {
  // In Shiny for Python meesage has to be an object. Path is send as field.
  const url = message.url; 
  window.location.hash = url;
}

Shiny.addCustomMessageHandler("_shiny_router_change_url", change_url);