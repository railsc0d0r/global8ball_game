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
    @yourCue.setTargetBall @white1
    @enemyCue.setTargetBall @white2
    @world.bringToTop @spriteGroups.cues
    @yourCue.show()

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
        x = @game.width  / 2 + @physics.p2.mpx ballConfig.position.x
        y = @game.height / 2 + @physics.p2.mpx ballConfig.position.y
        @[ballProperty] = @createSprite physicsGroupId, x, y, data: ballConfig, id: ballConfig.id

  whiteBallCollidesWithBorder: (ballBody, borderBody) =>

  whiteBallFallsIntoHole: (ballBody, holeBody) =>

  update: ->
    super()

  # @inheritdoc
  canShoot: ->
    not @youShot

  shoot: (power) ->
    @yourCue.shoot power
