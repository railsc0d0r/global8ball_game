#= require game/prolog

# Shot class.
class global8ball.Shot
  # @param {object} shotData
  # @param {string} shotData.user_id
  # @param {number} shotData.strength
  # @param {number} shotData.angle
  constructor: (shotData) ->
    @userId = shotData.user_id + ''
    @strength = shotData.strength
    @angle = shotData.angle

  # Checks wether this shot was done by the given player.
  #
  # @param {global8ball.Player} player
  # @return {boolean}
  wasDoneBy: (player) ->
    @userId is player.getId()
