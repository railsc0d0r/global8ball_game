#= require game/config/prolog
#= require game/config/Point

class global8ball.config.Balls
  BREAK_BALL = 'breakball'
  PLAY_BALL = 'playball'

  constructor: (ballsData) ->
    @balls = ballsData.map (ballData) -> new global8ball.config.Ball ballData

  getBreakBallsConfig: ->
    @balls.filter (ball) -> ball.type is BREAK_BALL

  getPlayBallsConfig: ->
    @balls.filter (ball) -> ball.type is PLAY_BALL

class global8ball.config.Ball
  constructor: (ballData) ->
    @id = ballData.id
    @type = ballData.type
    @color = ballData.color
    @owner = ballData.owner ? null
    @position = new global8ball.config.Point ballData.position.x, ballData.position.y

  belongsTo: (player) ->
    @owner is player.getId()
