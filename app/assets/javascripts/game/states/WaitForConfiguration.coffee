#= require game/prolog

# Waits for connection to the backend and retrieves the configuration for the
# game, i.e. table parameters, player information, current game stage, ball
# positions, etc.
# Depending on the received information, next state is one of the play states
# or showing results.
class global8ball.WaitForConfiguration extends Phaser.State
  CLEAR_WORLD = yes
  PRESERVE_CACHE = no

  # @param {global8ball.Backend} backend
  constructor: (@backend) ->

  create: ->
    @request 'table_parameters', 'TableParameters'
    @request 'player_information', 'PlayerInformation'
    @request 'game_state', 'GameState'

  request: (id, methodPart) ->
    @backend.request id, (error, response) => @['receive' + methodPart] response

  receiveTableParameters: (@tableParameters = null) ->

  receivePlayerInformation: (@playerInformation = null) ->

  receiveGameState: (@gameState = null) ->

  update: ->
    if @tableParameters and @playerInformation and @gameState
      @game.state.start @gameState.state, CLEAR_WORLD, PRESERVE_CACHE
