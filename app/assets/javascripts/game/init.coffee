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
    table: gameConfig.table
    player_1: gameConfig.player_1
    player_2: gameConfig.player_2
    current_viewer: gameConfig.current_viewer

  gameState =
    state: 'PlayForBegin'
  game = new global8ball.Game config, gameState
  game.start()
