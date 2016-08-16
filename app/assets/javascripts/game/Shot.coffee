#= require game/prolog

# Shot class.
class global8ball.Shot
  constructor: (shotData) ->
    @userId = shotData.user_id
    @strength = shotData.strength
    @angle = shotData.angle
