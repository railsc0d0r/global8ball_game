#= require game/sprites/Ball
#= require game/prolog
#= require game/states/PlayState

# State for determining which player may shoot first in the first round of
# normal play.
class global8ball.PlayForBegin extends global8ball.PlayState
  constructor: (gameConfig, players) ->
    super gameConfig, players
    @ballsData = []

  create: ->
    super()
    @youShot = no
    @enemyShot = no
    @createWhiteBalls()
    @yourCue.setTargetBall @yourBall
    @enemyCue.setTargetBall @enemyBall
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
    @ballsData.
      filter((ballData) -> ballData.id is 'you' or ballData.id is 'enemy').
      forEach (ballData) =>
        physicsGroupId = if ballData.id is 'you' then 'white1' else 'white2'
        ballProperty = if ballData.id is 'you' then 'yourBall' else 'enemyBall'
        @[ballProperty] = @createSprite physicsGroupId, ballData.pos.x, ballData.pos.y, data: ballData, id: ballData.id

  whiteBallCollidesWithBorder: (ballBody, borderBody) =>

  whiteBallFallsIntoHole: (ballBody, holeBody) =>

  update: ->
    super()

  # @inheritdoc
  canShoot: ->
    not @youShot

  shoot: (power) ->
    @yourCue.shoot power
