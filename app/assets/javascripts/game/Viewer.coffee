#= require game/prolog

# Represents the person who watches the game running in the browser. This may
# be one of the player or an unrelated spectator.
class global8ball.Viewer
  # @param {global8ball.Account} account
  constructor: (@account) ->

  # @return {string}
  getName: ->
    @account.name
