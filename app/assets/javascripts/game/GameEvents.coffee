#= require game/prolog

# Wraps Game signals API and provides some extras.
class global8ball.GameEvents
  constructor: ->
    @onShot = new Phaser.Signal
    @onSetState = new Phaser.Signal
    @onGetState = new Phaser.Signal
    @clearGameState()
    @onSetState.add (@state) =>

  # Wether there is a new game state pending or not.
  #
  # @return {boolean}
  hasGameState: ->
    @state isnt null

  # Returns the game state.
  #
  # @return {object}
  getGameState: ->
    @state

  # Clears the stored game state. If a game state was pending, it will be
  # deleted.
  clearGameState: ->
    @state = null

  # Requests a new game state. It may not be available immediately, but later
  # a game state will be there.
  requestNewGameState: ->
    @onGetState.dispatch()
