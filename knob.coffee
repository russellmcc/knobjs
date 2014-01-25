# ~readme.out~
# # Knob.js
# ## UI widgets for audio software in the browser

require 'polymer-platform'

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

# helper function to add properties to a class
addAttributesAsProperties = (obj, attrs) ->
  for attr in attrs then do (attr) ->
    Object.defineProperty obj, attr,
      enumerable: true
      configurable: true
      get: -> return obj.getAttribute attr
      set: (v) -> obj.setAttribute attr, v

# for now, we're using Polymer's custom elements polyfill.
# In the future, we'll use the Shadow DOM to replace the shadow
# of the semantically correct input#range control and
# not have to worry about this crap.
class knob.Knob extends HTMLInputElement
  createdCallback: ->
    @constructed = false
    @svg = document.createElementNS svgns, 'svg'
    @svg.setAttribute 'height', '100%'
    @svg.setAttribute 'width', '100%'
    @svg.setAttribute 'viewBox', '0 0 2 2'
    @svg.setAttribute 'preserveAspectRatio', 'none'
    @svg.setAttribute 'class', 'jsknob-knob'

    bg = document.createElementNS svgns, 'rect'
    bg.setAttribute 'width', '2'
    bg.setAttribute 'height', '2'
    bg.setAttribute 'class', 'jsknob-bg'
    @svg.appendChild bg

    @arcBg = document.createElementNS svgns, 'path'
    @arcBg.setAttribute 'class', 'jsknob-arcbg'
    @svg.appendChild @arcBg

    @arc = document.createElementNS svgns, 'path'
    @arc.setAttribute 'class', 'jsknob-arc'
    @svg.appendChild @arc

    @pointerState = {}

    new Listener {proxy: @, events:['pointerdown'], node: @}

    @appendChild @svg

    addAttributesAsProperties @, ['value', 'min', 'max', 'start-angle', 'angle-range', 'inner-radius', 'outer-radius', 'throw']
    for prop in ['start-angle', 'angle-range', 'inner-radius', 'outer-radius']
      @["#{prop}Changed"] = @recalcArc
    for prop in ['value', 'min', 'max']
      @["#{prop}Changed"] = @recalcValue

    @min = 0
    @max = 1000
    @value = 500
    @['start-angle'] = 5 / 4 * Math.PI
    @['angle-range'] = 3 / 2 * Math.PI
    @['inner-radius'] = .6
    @['outer-radius'] = .9
    @throw = 300
    @constructed = true
    @recalcArc()

  attributeChangedCallback: (attr) ->
    if attr is 'value'
      if (+@value >= +@min) and (+@value <= +@max)
        @dispatchEvent new Event 'change'
    @["#{attr}Changed"]?()

  getIDForEvent: (e) ->
    if e instanceof MouseEvent
      return 'mouse'
    return 'touch'

  pointerdown: (e) ->
    # this counts as a 'default' event since we're defining
    # an ad-hoc element type
    return if e.defaultPrevented
    @pointerState[@getIDForEvent e] = {
      listener: new Listener
        proxy: @
        events:['pointermove', 'pointerup']
        node: document
      clientX: e.clientX
      clientY: e.clientY
      startVal: @value
    }

  makeArcPath: (vRatio) ->
    a1 = @['start-angle']
    a2 = @['start-angle'] - vRatio * @['angle-range']
    ir = @['inner-radius']
    orr = @['outer-radius']
    x = 1 + orr * Math.cos a1
    y = 1 - orr * Math.sin a1
    ix = 1 + ir * Math.cos a1
    iy = 1 - ir * Math.sin a1
    largeArc = if a1 - a2 > Math.PI then 1 else 0
    x2 = 1 + orr * Math.cos a2
    y2 = 1 - orr * Math.sin a2
    ix2 = 1 + ir * Math.cos a2
    iy2 = 1 - ir * Math.sin a2
    return "M#{x},#{y} A#{orr},#{orr} 0 #{largeArc},1 #{x2},#{y2} L#{ix2},#{iy2} A#{ir},#{ir} 0 #{largeArc},0 #{ix},#{iy} Z"

  recalcArc: ->
    return unless @constructed
    @arcBg.setAttribute 'd', @makeArcPath 1
    @recalcValue()

  recalcValue: ->
    return unless @constructed
    @value = Math.max(@min, Math.min(@max, @value))
    @arc.setAttribute 'd', @makeArcPath (@value - @min) / (@max - @min)

  pointermove: (e) ->
    state = @pointerState[@getIDForEvent e]
    d = (e.clientX - state.clientX) + (state.clientY - e.clientY)
    d *= (@max - @min) / @throw
    @value = Math.max(@min, Math.min(@max, +state.startVal + d))
  pointerup: (e) ->
    @pointerState[@getIDForEvent e].listener.remove()
    delete @pointerState[@getIDForEvent e]

document.register 'x-jsknob-knob',
  prototype: knob.Knob::,
  extends: 'input'

module.exports = knob