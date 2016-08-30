#= require game/prolog

# In every game, two players are competing against each other. This class
# represents such a player.
class global8ball.Player
  # @param {global8ball.Account} account
  # @param {boolean} viewsTheGame
  constructor: (@account, @viewsTheGame) ->

  # @return {string}
  getName: () ->
    @account.name

  # @return {string}
  getId: () ->
    @account.id

  # @return {boolean}
  isViewer: () ->
    @viewsTheGame
