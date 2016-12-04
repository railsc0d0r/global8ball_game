#= require game/prolog

class global8ball.Ball extends Phaser.Sprite
  @TYPE = 'UNKNOWN'

  FIRST_BALL_POSITION =
    x: 6666
    y: 6666

  NEXT_BALL_OFFSET =
    x: 500
    y: 500

  setData: (@data) ->
    @id = @data.id

  removeFromTable: (index) ->
    @body.x = FIRST_BALL_POSITION.x + NEXT_BALL_OFFSET.x * index
    @body.y = FIRST_BALL_POSITION.y + NEXT_BALL_OFFSET.y * index
    @body.velocity.x = 0
    @body.velocity.y = 0
