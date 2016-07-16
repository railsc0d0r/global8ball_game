#= require game/sprites/Cue
#= require game/prolog
#= require game/states/FullState

# Base class for all states where players can play, i.e. there are cues, balls
# are shot, etc.
class global8ball.PlayState extends global8ball.FullState
  constructor: (gameConfig, eventSink, @hasUi = true) ->
    super gameConfig, eventSink

  init: (config) ->
    super config

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
