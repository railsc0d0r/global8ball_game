#= require game/config/Balls
#= require game/sprites/Ball
#= require game/prolog
#= require game/states/PlayState

# State for determining which player may shoot first in the first round of
# normal play.
class global8ball.PlayForBegin extends global8ball.PlayState
  constructor: (gameConfig, players) ->
    super gameConfig, players

  initGameState: (gameState) ->
    super gameState

  create: ->
    super()
    @youShot = no
    @enemyShot = no
    @createWhiteBalls()
    @cues.player1.setTargetBall @white1
    @cues.player2.setTargetBall @white2
    @world.bringToTop @spriteGroups.cues
    @cues.player1.setAngleByAim x: @white1.position.x + 10, y: @white1.position.y
    @cues.player2.setAngleByAim x: @white2.position.x + 10, y: @white2.position.y
    @cues.player1.show()

  getPhysicsGroupSpecs: () ->
    specs = super()
    specs.white1 =
      spriteKey: 'whiteBall'
      spriteGroupId: 'white'
      collisionGroupId: 'white1'
      collides: [
        {
          groupId: 'cue1'
        }
        {
          groupId: 'white2'
        }
        {
          groupId: 'borders'
          callback: 'whiteBallCollidesWithBorder'
        }
        {
          groupId: 'holes'
          callback: 'whiteBallFallsIntoHole'
        }
      ]
    specs.white2 =
      spriteKey: 'whiteBall'
      spriteGroupId: 'white'
      collisionGroupId: 'white2'
      collides: [
        {
          groupId: 'cue2'
        }
        {
          groupId: 'white1'
        }
        {
          groupId: 'borders'
          callback: 'whiteBallCollidesWithBorder'
        }
        {
          groupId: 'holes'
          callback: 'whiteBallFallsIntoHole'
        }
      ]
    specs.cue1.collides = [
      {
        groupId: 'white1'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]
    specs.cue2.collides = [
      {
        groupId: 'white2'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]

    specs.borders.collides = [
      {
        groupId: 'white1'
      }
      {
        groupId: 'white2'
      }
    ]

    specs.holes.collides = [
      {
        groupId: 'white1'
      }
      {
        groupId: 'white2'
      }
    ]

    return specs

  spriteClasses: () ->
    classes = super()
    classes.white1 = global8ball.Ball
    classes.white2 = global8ball.Ball
    return classes

  createWhiteBalls: () ->
    @ballsConfig.
      getBreakBallsConfig().
      forEach (ballConfig) =>
        ballProperty = if ballConfig.belongsTo @players.getFirst() then 'white1' else 'white2'
        physicsGroupId = ballProperty
        @[ballProperty] = @createBallSprite physicsGroupId, ballConfig

  whiteBallCollidesWithBorder: (ballBody, borderBody) =>

  whiteBallFallsIntoHole: (ballBody, holeBody) =>

  update: ->
    super()

  # @inheritdoc
  canShoot: ->
    not @youShot

  shoot: (power) ->
    @cues.player1.shoot power
