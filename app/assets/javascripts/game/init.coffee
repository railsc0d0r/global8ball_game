#= require game/Game

# Currently mostly for testing purposes.
# TODO: Implement gameConfig from backend
window.initGlobal8Ball = (gameConfig) ->
  config =
    imageUrlMap: window.assets.game
    parent: document.getElementById 'da-game'
    size:
      width: 800
      height: 600
    physicsConfig:
      mpx: (v) ->
        v * gameConfig.table.scaling_factor
      mpxi: (v) ->
        v * -(gameConfig.table.scaling_factor)
      pxm: (v) ->
        v / gameConfig.table.scaling_factor
      pxmi: (v) ->
        v / -(gameConfig.table.scaling_factor)

  gameState =
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
      id: 'david'
      name: 'David'
    state: 'PlayForBegin'
    balls: [
      {
        id: 'you'
        color: 'white'
        pos: x: -75, y: -25
      },
      {
        id: 'enemy'
        color: 'white'
        pos: x: -75, y: 25
      }
    ]
  game = new global8ball.Game config, gameState
  game.start()
