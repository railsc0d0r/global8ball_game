#= require game/prolog

# Wraps Game signals API and provides some extras.
class global8ball.GameEvents
  constructor: ->
    @onShot = new Phaser.Signal
    @onSetState = new Phaser.Signal
    @onGetState = new Phaser.Signal
    @clearGameState()
    @onSetState.add (@state) =>

  hasGameState: ->
    @state isnt null

  getGameState: ->
    @state

  clearGameState: ->
    @state = null

  requestNewGameState: ->
    @onGetState.dispatch()
