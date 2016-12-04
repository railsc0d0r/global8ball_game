#= require game/prolog
#= require game/sprites/CueAdder

class global8ball.CueAdder
  addCues: (state) ->
    setCueBody = (body) ->
      body.ccdSpeedThreshold = 1
      body.ccdIterations = 2
      body.damping = 0

    state.cues =
      player1: state.createSprite 'cue1', 10, 10, visible: no, setCueBody
      player2: state.createSprite 'cue2', 10, 10, visible: no, setCueBody
    state.world.bringToTop state.spriteGroups.cues
    state.cues.player1.setOwner state.players.getFirst()
    state.cues.player2.setOwner state.players.getSecond()
    state.cues.player1.initStates()
    state.cues.player2.initStates()
