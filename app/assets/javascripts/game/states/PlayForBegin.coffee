#= require game/config/Balls
#= require game/config/CurrentPlayers
#= require game/sprites/Ball
#= require game/prolog
#= require game/physics/GroupSpecs
#= require game/states/PlayState

# State for determining which player may shoot first in the first round of
# normal play.
class global8ball.PlayForBegin extends global8ball.PlayState
  constructor: (gameConfig, players, events) ->
    super gameConfig, players, events

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @youShot = no
    @enemyShot = no
    @createWhiteBalls()
    @cues.player1.setTargetBall @white1
    @cues.player2.setTargetBall @white2
    [@cues.player1, @cues.player2].forEach (cue) => @setInitialCueState cue
    @cues.player1.aimAt x: @white1.position.x + 10, y: @white1.position.y
    @cues.player2.aimAt x: @white2.position.x + 10, y: @white2.position.y

  getPhysicsGroupSpecs: () ->
    return (new global8ball.GroupSpecs).get 'common', 'play', 'twoWhiteBalls'

  # @return {Object.<string, function>} Map of classes
  spriteClasses: () ->
    classes = super()
    classes.white1 = global8ball.sprites.BreakBall
    classes.white2 = global8ball.sprites.BreakBall
    return classes

  createWhiteBalls: () ->
    @ballsConfig.
      getBreakBallsConfig().
      forEach (ballConfig) =>
        ballProperty = if ballConfig.belongsTo @players.getFirst() then 'white1' else 'white2'
        physicsGroupId = ballProperty
        @[ballProperty] = @createBallSprite physicsGroupId, ballConfig

  whiteBallCollidesWithBorder: (ballBody, borderBody) =>

  update: ->
    super()

  # @inheritdoc
  canShoot: ->
    not @youShot
