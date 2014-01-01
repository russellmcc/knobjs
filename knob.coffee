# ~readme.out~
# # Knob.js
# ## UI widgets for audio software in the browser

require 'pointerevents-polyfill'

svgns = 'http://www.w3.org/2000/svg'

knob = {}

# internal class to keep track of listening to multiple events
class Listener
  constructor: ({@proxy, @events, @node}) ->
    @events ?= Object.keys @proxy
    for event in @events
      @node.addEventListener event, @

  handleEvent: (e) ->
    @proxy[e.type](e)

  remove: ->
    for event in @events
      @node.removeEventListener event, @

class knob.Knob
  defaults:
    height: 100
    width: 100
    value: 50

  constructor: (node, @options) ->
    @options ?= {}
    @options[default_] ?= value for default_, value of @defaults

    @svg = document.createElementNS svgns, 'svg'
    @svg.setAttribute 'height', @options.height
    @svg.setAttribute 'width', @options.width

    # we want to capture all touch events
    @svg.style.touchEvents = 'none'
    @svg.setAttribute 'touch-event', 'none' # needed for polyfill

    Object.defineProperty @, 'value', {@get, @set, enumerable: true, configurable: true}
    Object.defineProperty @, '_value', {writable: true, configurable: true}
    {@_value} = @options

    @pointerState = {}

    new Listener {proxy: @, events:['pointerdown'], node: @svg}

    node.appendChild @svg

    # for now, just return the SVG node - in the future,
    # we'll use custom elements
    return @svg

  getIDForEvent: (e) ->
    if e instanceof MouseEvent
      return 'mouse'
    return 'touch'

  pointerdown: (e) ->
    @pointerState[@getIDForEvent e] = {
      listener: new Listener
        proxy: @
        events:['pointermove', 'pointerup']
        node: document
    }

  pointermove: (e) ->
    state = @pointerState[@getIDForEvent e]

  pointerup: (e) ->
    @pointerState[@getIDForEvent e].listener.remove()
    delete @pointerState[@getIDForEvent e]

  get: -> return @_value
  set: (v) -> @_value = v

module.exports = knob