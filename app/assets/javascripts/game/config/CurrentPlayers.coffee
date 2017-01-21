#= require game/config/prolog

class global8ball.config.CurrentPlayers
  # @param {Array} currentPlayersData
  constructor: (currentPlayersData) ->
    @userIds = currentPlayersData.map (currentPlayerData) -> currentPlayerData.user_id + ''

  # Returns user IDs.
  #
  # @return {string[]}
  getUserIds: ->
    @userIds

  # Checks if the given player is one of the current players.
  #
  # @param {global.Player} player
  # @return {boolean}
  contains: (player) ->
    @userIds.includes player.getId()
