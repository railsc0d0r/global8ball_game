#= require game/prolog

# Wraps Game signals API and provides some extras.
class global8ball.GameEvents
  constructor: ->
    @onSendShot = new Phaser.Signal
    @onReceiveShot = new Phaser.Signal
    @clearShot()
    @onReceiveShot.add (@shot) =>

    @onSetState = new Phaser.Signal
    @onGetState = new Phaser.Signal
    @clearGameState()
    @onSetState.add (@state) =>

  # Wether there is a new shot pending or not.
  #
  # @return {boolean}
  hasShot: ->
    @shot isnt null

  # Returns the shot.
  #
  # @return {object}
  getShot: ->
    @shot

  # Clears the stored shot. If a shot was pending, it will be
  # deleted.
  clearShot: ->
    @shot = null

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
