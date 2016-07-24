#= require game/prolog
#= require game/states/PlayState

# State for handling the part of the game where both players compete to win
# rounds.
class global8ball.PlayForVictory extends global8ball.PlayState
  PLAY_BALL_COLOR_MAPPING =
    red: 'redBall'
    gold: 'yellowBall'

  constructor: (gameConfig, players) ->
    super gameConfig, players

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @createWhiteBall()
    @createPlayBalls()
    @world.bringToTop @spriteGroups.playBalls

  createWhiteBall: () ->
    @white = @createBallSprite 'white', @ballsConfig.getBreakBallsConfig()[0]

  createPlayBalls: () ->
    @playBalls = @ballsConfig.getPlayBallsConfig().forEach (ballConfig) =>
      @createBallSprite 'playBalls', ballConfig, PLAY_BALL_COLOR_MAPPING[ballConfig.color]

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
          groupId: 'black'
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
      spriteGroupId: 'black'
      collisionGroupId: 'black'
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
