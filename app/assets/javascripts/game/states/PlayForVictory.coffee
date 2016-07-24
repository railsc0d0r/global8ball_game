#= require game/prolog
#= require game/states/PlayState

# State for handling the part of the game where both players compete to win
# rounds.
class global8ball.PlayForVictory extends global8ball.PlayState
  constructor: (gameConfig, players) ->
    super gameConfig, players

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()

  update: ->
    super()

  getPhysicsGroupSpecs: () ->
    specs = super()

    specs.white =
      spriteKey: 'whiteBall'
      spriteGroupId: 'white'
      collisionGroupId: 'white'
      collides: [
        {
          groupId: 'cue1'
        }
        {
          groupId: 'cue2'
        }
        {
          groupId: 'borders'
        }
        {
          groupId: 'holes'
          callback: 'whiteBallFallsIntoHole'
        }
        {
          groupId: 'playBalls'
        }
        {
          groupId: 'blackBall'
        }
      ]

    specs.playBalls =
      spriteGroupId: 'playBalls'
      collisionGroupId: 'playBalls'
      collides: [
        {
          groupId: 'white'
        }
        {
          groupId: 'black'
        }
      ]

    specs.black =
      spriteKey: 'blackBall'
      spriteGroupId: 'blackBall'
      collisionGroupId: 'blackBall'
      collides: [
        {
          groupId: 'white'
        }
        {
          groupId: 'playBalls'
        }
      ]

    specs.cue1.collides = [
      {
        groupId: 'white'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]

    specs.cue2.collides = [
      {
        groupId: 'white'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]
    return specs
