#= require game/Controls
#= require game/Players
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
    @request 'player_information', 'PlayerInformation'
    @request 'game_state', 'GameState'

  request: (id, methodPart) ->
    @backend.request id, (error, response) => @['receive' + methodPart] response

  receivePlayerInformation: (playerInformation = null) ->
    @players = global8ball.Players.create playerInformation.players, playerInformation.viewer
    if @players.viewerPlays()
      controls = new global8ball.Controls (power) => @state.states[@state.current].shoot power
      controls.attach @state.states.PlayForBegin
      controls.attach @state.states.PlayForVictory

  receiveGameState: (@gameState = null) ->

  update: ->
    if @players and @gameState
      config =
        players: @players
      @game.state.start @gameState.state, CLEAR_WORLD, PRESERVE_CACHE, config
