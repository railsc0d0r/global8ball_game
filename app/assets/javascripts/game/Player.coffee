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

# Creates a player which is also a viewer.
#
# @param {global8ball.Account} account
# @return {global8ball.Player}
global8ball.Player.createViewingPlayer = (account) ->
  new global8ball.Player account, true

# Creates a player which is not a viewer.
#
# @param {global8ball.Account} account
# @return {global8ball.Player}
global8ball.Player.createNonViewingPlayer = (account) ->
  new global8ball.Player account, false
