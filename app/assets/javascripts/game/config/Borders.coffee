#= require game/config/prolog
#= require game/config/Point

class global8ball.config.Borders
  constructor: (bordersData) ->
    @borders = bordersData.map (borderData) -> new global8ball.config.Border borderData

class global8ball.config.Border
  constructor: (borderData) ->
    @vertices = borderData.map (pointData) -> new global8ball.config.Point pointData.x, pointData.y
