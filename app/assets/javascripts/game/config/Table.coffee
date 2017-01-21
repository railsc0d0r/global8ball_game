#= require game/config/prolog

class global8ball.config.Table
  constructor: (@data) ->

  getDamping: ->
    @data.damping

  getMaximumBreakballSpeed: ->
    @data.max_breakball_speed
