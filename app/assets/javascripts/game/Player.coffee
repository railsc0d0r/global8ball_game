#= require game/prolog

# In every game, two players are competing against each other. This class
# represents such a player.
class global8ball.Player
  # @param {global8ball.Account} account
  constructor: (@account) ->

  # @return {string}
  getName: () ->
    @account.name

  # @return {string}
  getId: () ->
    @account.id
