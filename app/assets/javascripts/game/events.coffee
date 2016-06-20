#= require game/prolog

global8ball.events = global8ball.events or {}

class global8ball.events.EventSink
  send: (event) ->

class global8ball.events.ShotEvent
  constructor: (@angle, @strength) ->
