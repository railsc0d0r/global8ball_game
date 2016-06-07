#= require game/prolog
#= require game/phaser

class global8ball.Ball extends Phaser.Sprite
  setData: (@data) ->
    @id = @data.id
