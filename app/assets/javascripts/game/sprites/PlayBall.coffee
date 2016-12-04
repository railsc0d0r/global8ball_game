#= require game/sprites/prolog
#= require game/sprites/Ball

class global8ball.sprites.PlayBall extends global8ball.Ball
  @TYPE = 'PLAY_BALL'

  @BALL_COLOR_MAPPING =
    red: 'redBall'
    gold: 'yellowBall'
