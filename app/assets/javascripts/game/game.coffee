#= require game/prolog

FORCE_FACTOR = 10
MAX_FORCE = 1000

class global8ball.Ball extends Phaser.Sprite
  setData: (@data) ->
    @id = @data.id

class global8ball.Cue extends Phaser.Sprite
  LENGTH = 250
  MATH_FACTOR = Math.PI/180

  power: 0
  targetBall: null

  hide: ->
    @visible = no

  show: ->
    if @targetBall
      @updatePosition()
      @visible = yes

  setTargetBall: (@targetBall) ->
    @updatePosition()

  # @param {number} newAngle New angle in degrees (0-360)
  setAngle: (newAngle) ->
    @body.angle = newAngle
    @updatePosition()

  # @param {Point} Position to aim at. The cue will point TO that position, not FROm it!
  setAngleByAim: (pos) ->
    if @targetBall
      @setAngle Math.atan2(@targetBall.body.y - pos.y, @targetBall.body.x - pos.x) / MATH_FACTOR

  updatePosition: ()->
    if @targetBall
      @body.x = @targetBall.x + LENGTH * Math.cos(MATH_FACTOR * @body.angle)
      @body.y = @targetBall.y + LENGTH * Math.sin(MATH_FACTOR * @body.angle)

class global8ball.Hole extends Phaser.Sprite

class global8ball.EventSource
  youShot: () ->
    false

  enemyShot: () ->
    false

###
Factory class for creating sprites. Combines both a sprite group and a
collision group, and automatically adds assigned collision callbacks.
The class of the created sprites is controlled by the Phaser sprite group given
on construction.
###
class global8ball.PhysicsGroup

  # @param {string} spriteKey Phaser sprite key used when creating sprites.
  # @param {Phaser.Group} spriteGroup Phaser sprite group used for sprite creation.
  # @param {Phaser.Physics.CollisionGroup} collisionGroup Phaser collision group created sprites use.
  constructor: (@spriteKey, @spriteGroup, @collisionGroup) ->
    @collisionSpecs = []

  # Let sprites created collide with the given collision group(s).
  #
  # @param {Phaser.Physics.CollisionGroup|Phaser.Physics.CollisionGroup[]} collisionGroup
  # @param {function} callback Optional callback when a collision happens.
  # @param {object} callbackContext Used as context for the callback. Optional.
  # @return {global8ball.PhysicsGroup} This (for chaining).
  collides: (collisionGroup, callback, callbackContext) ->
    @collisionSpecs.push group: collisionGroup, callback: callback, context: callbackContext
    return @

  # Creates a sprite.
  #
  # @param {number} x X coordinate of the new sprite.
  # @param {number} y Y coordinate of the new sprite.
  # @param {object} config Additional configuration, directly applied to the sprite. Optional.
  # @return {Phaser.Sprite|object}
  create: (x, y, config = {}) ->
    sprite = @spriteGroup.create x, y, @spriteKey
    for prop of config
      sprite[prop] = config[prop]
    sprite.body.setCollisionGroup @collisionGroup
    @collisionSpecs.forEach (collision) ->
      sprite.body.collides collision.group, collision.callback, collision.context
    return sprite

class global8ball.Player
  constructor: (@id) ->
