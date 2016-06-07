#= require game/Cue
#= require game/prolog
#= require game/states/FullState

class global8ball.PlayState extends global8ball.FullState
  constructor: (g8bGame, @hasUi = true) ->
    super(g8bGame)

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

  # A cue collides with a (white) ball. Immediately get the cue out of the way
  # by teleporting it outside the game. Also, makes it invisible.
  cueCollidesWithWhiteBall: (cue, ball) =>
    cue.x = -1000
    cue.y = -1000
    cue.visible = no
