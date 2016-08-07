#= require game/prolog
#= require game/states/PlayState

# State for handling the part of the game where both players compete to win
# rounds.
class global8ball.PlayForVictory extends global8ball.PlayState
  PLAY_BALL_COLOR_MAPPING =
    red: 'redBall'
    gold: 'yellowBall'

  constructor: (gameConfig, players, events) ->
    super gameConfig, players, events

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @createWhiteBall()
    @createPlayBalls()
    @createBlackBall()
    @world.bringToTop @spriteGroups.cues
    @cues.player1.setTargetBall @white
    @cues.player2.setTargetBall @white
    @cues.player1.putOnTable()
    @cues.player2.retreatFromTable()
    @cues.player1.aimAt x: @white.position.x + 10, y: @white.position.y
    @cues.player2.aimAt x: @white.position.x + 10, y: @white.position.y

  createWhiteBall: () ->
    @white = @createBallSprite 'white', @ballsConfig.getBreakBallsConfig()[0]

  createPlayBalls: () ->
    @playBalls = @ballsConfig.getPlayBallsConfig().forEach (ballConfig) =>
      @createBallSprite 'playBalls', ballConfig, PLAY_BALL_COLOR_MAPPING[ballConfig.color]

  createBlackBall: () ->
    @blackBall = @createBallSprite 'black', @ballsConfig.get8BallConfig()

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
        {
          groupId: 'playBalls'
        }
        {
          groupId: 'borders'
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
        {
          groupId: 'borders'
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

    specs.borders.collides = [
      {
        groupId: 'playBalls'
      }
      {
        groupId: 'black'
      }
      {
        groupId: 'white'
      }
    ]

    return specs
