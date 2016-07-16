#= require game/Controls
#= require game/Players
#= require game/prolog

# Waits for a game state receive event. Intermediate state used after booting
# or shooting.
# Depending on the received information, next state is one of the play states
# or showing results.
class global8ball.WaitForGameState extends Phaser.State
  constructor: (@events) ->

  create: ->
    @events.requestNewGameState()

  update: ->
      if @events.hasGameState()
        gameState = @events.getGameState()
        @events.clearGameState()
        @game.state.start gameState.current_stage.stage_name
