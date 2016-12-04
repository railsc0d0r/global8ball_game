#= require game/prolog
#= require game/physics/GroupSpecs
#= require game/sprites/BreakBall
#= require game/sprites/Global8Ball
#= require game/sprites/PlayBall
#= require game/states/PlayState

# State for handling the part of the game where both players compete to win
# rounds.
class global8ball.PlayForVictory extends global8ball.PlayState
  constructor: (gameConfig, players, events) ->
    super gameConfig, players, events

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @createWhiteBall()
    @createPlayBalls()
    @createBlackBall()
    @cues.player1.setTargetBall @white
    @cues.player2.setTargetBall @white
    [@cues.player1, @cues.player2].forEach (cue) => @setInitialCueState cue
    @cues.player1.aimAt x: @white.position.x + 10, y: @white.position.y
    @cues.player2.aimAt x: @white.position.x + 10, y: @white.position.y

  spriteClasses: () ->
    classes = super()
    classes.white = global8ball.sprites.BreakBall
    classes.black = global8ball.sprites.Global8Ball
    classes.playBalls = global8ball.sprites.PlayBall
    return classes

  createWhiteBall: () ->
    @white = @createBallSprite 'white', @ballsConfig.getBreakBallsConfig()[0]

  createPlayBalls: () ->
    @playBalls = @ballsConfig.getPlayBallsConfig().forEach (ballConfig) =>
      @createBallSprite 'playBalls', ballConfig, global8ball.sprites.PlayBall.BALL_COLOR_MAPPING[ballConfig.color]

  createBlackBall: () ->
    @blackBall = @createBallSprite 'black', @ballsConfig.get8BallConfig()

  update: ->
    super()

  getPhysicsGroupSpecs: () ->
    return (new global8ball.GroupSpecs).get 'common', 'play', 'oneWhiteBall', 'blackBall', 'playBalls'
