# ~readme.out~
# # Knob.js
# ## UI widgets for audio software in the browser

_ = require 'underscore'

svgns = 'http://www.w3.org/2000/svg'

knob = {}

class knob.Knob
  defaults:
    height: 100
    width: 100
  constructor: (node, @options) ->
    @options ?= {}
    _.defaults @options, @defaults
    @svg = document.createElementNS svgns, 'svg'
    @svg.height = @options.height
    @svg.width = @options.width

    node.appendChild @svg

module.exports = knob