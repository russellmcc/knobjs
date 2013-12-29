#!/bin/sh
bower install
beefy knob.coffee:knob.min.js $npm_package_config_port -- -t coffeeify -t debowerify --standalone knob
