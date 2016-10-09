#= require game/Game

# Currently mostly for testing purposes.
this.initGlobal8Ball = (gameConfig) ->
  config =
    imageUrlMap: window.assets.game
    parent: document.getElementById 'da-game'
    size:
      width: 800
      height: 600
    holes: gameConfig.holes
    borders:gameConfig.borders
    tableDamping: gameConfig.table.damping
    cue:
      hardness: gameConfig.table.cue_hardness
      mass: gameConfig.table.cue_mass
    physicsConfig:
      mpx: (v) ->
        v * gameConfig.table.scaling_factor
      mpxi: (v) ->
        v * -(gameConfig.table.scaling_factor)
      pxm: (v) ->
        v / gameConfig.table.scaling_factor
      pxmi: (v) ->
        v / -(gameConfig.table.scaling_factor)
    players:
      first:
        id: gameConfig.player_1.user_id
        name: gameConfig.player_1.name
        shot: false
      second:
        id: gameConfig.player_2.user_id
        name: gameConfig.player_2.name
        shot: false
    viewer:
      id: gameConfig.current_viewer.user_id
      name: gameConfig.current_viewer.name
    breakBall:
      maxSpeed: gameConfig.table.max_breakball_speed

  gameState =
    state: 'PlayForBegin'
  game = new global8ball.Game config, gameState
  game.start()
