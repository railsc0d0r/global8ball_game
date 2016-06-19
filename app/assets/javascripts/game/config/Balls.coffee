#= require game/config/prolog
#= require game/config/Point

class global8ball.config.Balls
  constructor: (ballsData) ->
    @balls = ballsData.map (ballData) -> new global8ball.config.Ball ballData

class global8ball.config.Ball
  constructor: (ballData) ->
    @id = ballData.id
    @type = ballData.type
    @color = ballData.color
    @owner = ballData.owner ? null
    @position = new global8ball.config.Point ballData.position.x, ballData.position.y
