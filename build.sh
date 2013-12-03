#!/bin/sh
coffee -c -m knob.coffee
uglifyjs --source-map knob.min.map --in-source-map knob.map -o knob.min.js knob.js