#= require game/config/prolog
#= require game/config/Point

class global8ball.config.Balls
  BREAK_BALL = 'breakball'
  PLAY_BALL = 'playball'
  EIGHT_BALL = '8ball';

  constructor: (ballsData) ->
    @balls = ballsData.map (ballData) -> new global8ball.config.Ball ballData

  # @return global8ball.config.Ball[]
  getBreakBallsConfig: ->
    @balls.filter (ball) -> ball.type is BREAK_BALL

  # @return global8ball.config.Ball[]
  getPlayBallsConfig: ->
    @balls.filter (ball) -> ball.type is PLAY_BALL

  # @return global8ball.config.Ball[]
  get8BallConfig: ->
    @balls.filter((ball) -> ball.type is EIGHT_BALL)[0]

class global8ball.config.Ball
  constructor: (ballData) ->
    @id = ballData.id
    @type = ballData.type
    @color = ballData.color
    @owner = ballData.owner ? null
    @position = new global8ball.config.Point ballData.position.x, ballData.position.y
    @radius = ballData.radius
    @mass = ballData.mass

  # @param {global8ball.Player} player
  # @return boolean
  belongsTo: (player) ->
    @owner is player.getId()
