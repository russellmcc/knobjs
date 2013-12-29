#!/bin/sh
bower install
browserify -t coffeeify -t debowerify -t uglifyify knob.coffee --standalone knob -o knob.min.js
