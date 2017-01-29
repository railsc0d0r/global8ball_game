#= require game/prolog
#= require game/states/FullState

class global8ball.Reinstate extends global8ball.FullState
  constructor: (gameConfig, players, events) ->
    super gameConfig, players, events

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @ballToReinstate = @createSprite 'reinstateBall', -1000, -1000, { spriteKey: 'whiteBall' }
    @input.addMoveCallback @setReinstateBallPosition, @

  setReinstateBallPosition: (pointer, x, y, wasClick) ->
    @ballToReinstate.body.x = x
    @ballToReinstate.body.y = y

  getPhysicsGroupSpecs: ->
    return (new global8ball.GroupSpecs).get 'common', 'reinstate'

  # @return {Object.<string, function>} Map of classes
  spriteClasses: ->
    classes = super()
    classes.reinstateBall = global8ball.ReinstateBall
    return classes

  update: ->
    super()
