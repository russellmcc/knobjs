#!/bin/sh
browserify -t coffeeify -t debowerify -t uglifyify knob.coffee --standalone knob > knob.min.js
