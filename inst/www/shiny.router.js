/**
 * A good old-fashioned ES5 fake module.
 * See https://medium.com/@crohacz_86666/basics-of-modular-javascript-2395c82dd93a
 * @todo: Turn this into a good new-fashioned ES6 module?
 * @todo: minify.
 */
window.shiny_router = function() {
  const ROUTER_INPUT_ID = 'shiny_router_inputId'

  current_context = false;

  /**
   * A reference to the callback function that Shiny sends us, which we're
   * meant to call whenever the input has updated.
   */
  var shinyTriggerUpdateFn = false;

  page("*", function(context, next){
    // TODO: remove this
    console.log("Middleware called", context, next);
    // So, this eliminates the route validation. But it also eliminates the
    // need to communicate the routes back from the server-side to the
    // client-side!
    current_context = context;
    if (false !== shinyTriggerUpdateFn) {
      console.log("Telling shiny we have an upate!")
      shinyTriggerUpdateFn();
    } else {
      console.log("Still no shiny trigger function.")
    }
  })
  page({
    hashbang: true, // Use hashbang-based paths, e.g. "http://example.com/#!item?id="
    click: false // Don't set up a full-page click handler that attempts
                 // to intercept clicks and see whether they should be routed
  });

  /**
   * To fit into the Shiny lifecycle nicely, we'll use an InputBinding. In order
   * for end-to-end communication to work correctly, we'll need an actual HTML
   * element on the page. The router_ui() R method takes care of this for us
   * by providing a hidden input tag.
   */
  var inputBinding = new Shiny.InputBinding();
  jQuery.extend(inputBinding, {
    find: function(scope) {
      return jQuery("input#" + ROUTER_INPUT_ID);
    },
    getId: function(el) {
      // There should only be exactly one instance, so we know its ID.
      return ROUTER_INPUT_ID
    },
    /**
     * When it tries to get the value of the input, we just retrieve it from
     * the cookie (if present)
     */
    getValue: function(el) {
      // TODO: remove this
      console.log("shiny.router::getValue", current_context);
      if (current_context) {
        var v = {
          page: current_context.pathname,
          page_with_params: current_context.path
        };
        console.log("returning: ", v);
        return v;
      } else {
        return false;
      }
    },
    setValue: function(el, value) {},
    subscribe: function(el, callback) {
      // Make the callback available for us to invoke it manually.
      shinyTriggerUpdateFn = callback;
    },
    unsubscribe: function(el) {
      shinyTriggerUpdateFn = false;
    },
    receiveMessage: function(el, data) {
      // TODO: remove this
      console.log("shiny.router::receiveMessage", el, data);
      // We can use messages from Shiny to change the currently loaded page.
      page(data);
    }
  });

  Shiny.inputBindings.register(inputBinding, "shiny.router");

  /**
   * The things that will be accessible under window.shiny_router
   */
  return {
    // We don't actually need to return anything right now. The API is entirely
    // self-contained, and only does anything when initialized.
  };
}();
