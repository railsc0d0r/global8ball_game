#= require game/prolog

class global8ball.ShotStrength
  constructor: (@changeSpeed = 0.001) ->
    @currentChange = 0
    @value = 0.5

  get: () ->
    @value

  setTo: (newValue) ->
    @value = Math.min 1, Math.max 0, newValue

  startStrengthening: () ->
    @currentChange = @changeSpeed

  startLessening: () ->
    @currentChange = -@changeSpeed

  stopChanging: () ->
    @currentChange = 0

  isChanging: () ->
    @currentChange isnt 0

  update: () ->
    @setTo @get() + @currentChange
