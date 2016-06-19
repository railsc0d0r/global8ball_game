#= require game/config/prolog
#= require game/config/Point

class global8ball.config.Holes
  constructor: (holesData) ->
    @holes = holesData.map (holeData) -> new global8ball.config.Hole holeData

class global8ball.config.Hole
  constructor: (holeData) ->
    @position = new global8ball.config.Point holeData.x, holeData.y
    @radius = holeData.radius
