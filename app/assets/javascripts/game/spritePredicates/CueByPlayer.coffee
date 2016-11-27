#= require game/spritePredicates/prolog

class global8ball.spritePredicates.CueByPlayer
  constructor: (player) ->
    return (sprite) ->
      sprite.spriteType is global8ball.Cue.TYPE && player.equals sprite.getOwner()
