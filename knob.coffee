# ~readme.out~
# # Knob.js
# ## UI widgets for audio software in the browser

require 'pointerevents-polyfill'

svgns = 'http://www.w3.org/2000/svg'

knob = {}

class knob.Knob
  defaults:
    height: 100
    width: 100
  constructor: (node, @options) ->
    @options ?= {}
    @options[default_] ?= value for default_, value of @defaults
    
    @svg = document.createElementNS svgns, 'svg'
    @svg.setAttribute 'height', @options.height
    @svg.setAttribute 'width', @options.width

    # we want to capture all touch events
    @svg.style.touchEvents = 'none'
    @svg.setAttribute 'touch-event', 'none' # needed for polyfill

    node.appendChild @svg

module.exports = knob