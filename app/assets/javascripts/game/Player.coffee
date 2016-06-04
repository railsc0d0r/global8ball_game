#= require game/prolog

# In every game, two players are competing against each other. This class
# represents such a player.
class global8ball.Player
  constructor: (@account) ->

  # @return {string}
  getName: () ->
    @account.name
