#= require game/sprites/Cue
#= require game/prolog
#= require game/states/FullState

# Base class for all states where players can play, i.e. there are cues, balls
# are shot, etc.
class global8ball.PlayState extends global8ball.FullState
  constructor: (gameConfig, players, @hasUi = true) ->
    super gameConfig, players
    @ballsConfig = []

  init: (gameState) ->
    super()
    @initGameState gameState

  initGameState: (gameState) ->
    @ballsConfig = new global8ball.config.Balls gameState.balls

  create: ->
    super()
    @yourCue = @createSprite 'cue1', 10, 10, visible: no
    @enemyCue = @createSprite 'cue2', 10, 10, visible: no

  getPhysicsGroupSpecs: () ->
    specs = super()
    specs.cue1 =
      spriteKey: 'cue'
      spriteGroupId: 'cues'
      collisionGroupId: 'cue1'
    specs.cue2 =
      spriteKey: 'cue'
      spriteGroupId: 'cues'
      collisionGroupId: 'cue2'
    return specs

  spriteClasses: () ->
    classes = super()
    classes.cues = global8ball.Cue
    return classes

  update: ->
    super()

  aimAt: (x, y) ->
    @yourCue.setAngleByAim x: x, y: y

  # @return {Boolean}
  canShoot: ->
    no

  # A cue collides with a (white) ball. Immediately make the cue go away.
  cueCollidesWithWhiteBall: (cueBody, ballBody) =>
    cueBody.sprite.retreatFromTable()

  shoot: (power) ->

  createBallSprite: (physicsGroupId, ballConfig, spriteKey = null) ->
    x = @game.width  / 2 + @physics.p2.mpx ballConfig.position.x
    y = @game.height / 2 + @physics.p2.mpx ballConfig.position.y
    makeCircularBody = (body) ->
      body.clearShapes()
      radius = 10 # TODO: Receive from backend
      offsetX = 0
      offsetY = 0
      rotation = 0
      body.addCircle radius, offsetX, offsetY, rotation
    config = data: ballConfig
    if spriteKey
      config.spriteKey = spriteKey
    ball = @createSprite physicsGroupId, x, y, config, makeCircularBody
    ball.body.applyDamping @gameConfig.config.tableDamping

    ball
