#= require game/Game

# Currently mostly for testing purposes.
# The real game will take data and events from the server.
window.initGlobal8Ball = (e) ->
  config =
    imageUrlMap: window.assets.game
    parent: document.getElementById 'da-game'
    size:
      width: 800
      height: 600
    physicsConfig:
            mpx: (v) ->
                    return v * 377.95
            mpxi: (v) ->
                    return v * -377.95
            pxm: (v) ->
                    return v / 377.95
            pxmi: (v) ->
                    return v / -377.95
  gameState =
    players:
      first:
        id: 'david'
        name: "David"
        shot: false
      second:
        id: 'goliath'
        name: "Goliath"
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
