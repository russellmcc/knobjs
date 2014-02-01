# `knob.js`
UI widgets for music software in the browser.

## How to get it

For your convenience:

`npm`:

    npm install knobjs

`bower`:

    bower install knobjs

or, just hotlink the file:

    <script type="text/javascript" src="http://www.russellmcc.com/knobjs/knob.min.js"></script>

## Live Demo

[on github pages](http://www.russellmcc.com/knobjs/)

## Basic Usage

First, include `knob.min.js`, using [`require.js`](http://requirejs.org/), [`browserify`](http://browserify.org/), any [amd](http://en.wikipedia.org/wiki/Asynchronous_module_definition) or [commonjs](http://en.wikipedia.org/wiki/CommonJS) loader, or just a `<script>` tag.

Then, include some sort of styling for the knobs.  You can include the included `knobjs.css` or [create your own style](#styling)

Then, create an element of type `x-knobjs-knob`.  You can either use an html tag or [`document.createElement("x-knobjs-knob")`](https://developer.mozilla.org/en-US/docs/Web/API/document.createElement).

To get access to the element from JavaScript without jQuery, you might find [`document.querySelector`](https://developer.mozilla.org/en-US/docs/Web/API/document.querySelector) and [`document.getElementById`](https://developer.mozilla.org/en-US/docs/Web/API/document.getelementbyid) useful.

The read-write `value` attribute of the element will correspond to the knob's current position (by default, from 0-100).  To listen to changes, add an event listener to the `change` event, which occurs whenever the value changes.  You can either use [`element.onchage = f`](https://developer.mozilla.org/en-US/docs/Web/API/GlobalEventHandlers.onchange) or [`element.addEventListener('change', f)`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget.addEventListener)

For an example of all this, see the example included in `examples/simple.html` and `examples/manyknobs.html`

## Advanced Usage

The behavior of the knob can be controlled by setting any of the following attributes, either through JavaScript [`element.setAttribute`](https://developer.mozilla.org/en-US/docs/Web/API/Element.setAttribute) or HTML.  The following settings can be changed:

 * `value`: The current value of the knob.  Clipped between `min` and `max`. Default: `50`.
 * `min`: The minimum value of the knob.  Default: `0`
 * `max`: The maximum value of the knob.  Default: `100`
 * `start-angle`: the angle in radians at which the knob's arc starts. Default: `5 / 8 Tau`
 * `angle-range`: the angle range of the knob's arc in radians.  Default: `3/4 Tau`.
 * `inner-radius`: the radius of the inner part of the knob's arc, relative to the size of the knob element.  Default: `0.7`
 * `outer-radius`: the radius of the outer part of the knob's arc, relative to the size of the knob element.  Default: `0.9`
 * `throw`: the number of pixels of mouse dragging it takes to go from the `min` to the `max`.  Default: `300`

## Styling
<a id="styling"></a>

To style sub-elements of the knob, apply CSS styles to the following classes:

 * `.knobjs-bg`: the background of the entire knob element
 * `.knobjs-arcbg`: the full arc
 * `.knobjs-arc`: the arc that displays the current value.

Each of these sub elements is an [`SVG` element](http://www.w3.org/TR/SVG/styling.html#StylingWithCSS), and any applicable style will work.  The ones that you probably want to use most commonly are `fill`, `stroke-width`, and `stroke`.  The `.knobjs-arcbg` element by default has a mask that only allows it to display outside of the path of the `.knobjs-arc`.  To disable this just add a `mask: none;` style.

## Under the Hood

The slightly "magic" features of this library are all provided by [polymer platform](http://www.polymer-project.org/platform/custom-elements.html), a polyfill for future browser features.  This means a relatively contemporary browser is required.

## Future

`knob.js` was designed for a future where browsers have web app features like the Shadow DOM.  For now, semantic markup has been sacrificed to get the project to work on current browsers.  Once the Shadow DOM and CSS variables are relatively widely supported, knob.js will be redesigned as an alternate shadow DOM for an `input` element of `range` type, restoring semantic correctness to your markup.  Presentational attributes like `outer-radius` and friends will be moved into a stylesheet, and `.knobjs-bg` and friends will become pseudo-elements.

## Performance

Every effort was made to make `knob.js` as performant as possible.  Currently, it is possible to have several hundred knobs move simultaneously on a fast computer on a browser with a good JavaScript engine.  The current bottleneck seems to be the polymer platform's Shadow DOM emulation.  Hopefully this bottleneck will be removed once the Shadow DOM sees wider support.  In the mean time, pull requests to improve performance are encouraged.

## License

Boost Software License.  See `COPYING`.
