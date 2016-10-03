#= require game/prolog

class global8ball.Ball extends Phaser.Sprite
  setData: (@data) ->
    @id = @data.id
