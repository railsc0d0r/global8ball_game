#= require game/config/prolog

class global8ball.config.CurrentPlayers
  # @param {Array} currentPlayersData
  constructor: currentPlayersData ->
    @userIds = currentPlayersData.map (currentPlayerData) -> currentPlayerData.user_id

  # Returns user IDs.
  #
  # @return {integer[]}
  getUserIds: ->
    @userIds
