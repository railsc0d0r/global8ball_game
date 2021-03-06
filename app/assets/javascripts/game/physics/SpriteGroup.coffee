#= require game/prolog

###
Factory class for creating sprites. Combines both a sprite group and a
collision group, and automatically adds assigned collision callbacks.
The class of the created sprites is controlled by the Phaser sprite group given
on construction.
###
class global8ball.SpriteGroup

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
  # @return {global8ball.SpriteGroup} This (for chaining).
  collides: (collisionGroup, callback, callbackContext) ->
    @collisionSpecs.push group: collisionGroup, callback: callback, context: callbackContext
    return @

  # Creates a sprite.
  #
  # @param {number} x X coordinate of the new sprite.
  # @param {number} y Y coordinate of the new sprite.
  # @param {object} config Additional configuration, directly applied to the sprite. Optional.
  # @param {function} bodyModifier Modifies the body before applying collision specs.
  # @return {Phaser.Sprite|object}
  create: (x, y, config = {}, bodyModifier = (body) ->) ->
    sprite = @spriteGroup.create x, y, config.spriteKey ? @spriteKey
    for prop of config
      if prop isnt 'spriteKey'
        sprite[prop] = config[prop]
    bodyModifier sprite.body
    @applyCollisions sprite
    return sprite

  # Apply collision configuration to a sprite.
  #
  # @param {Phaser.Sprite} sprite
  applyCollisions: (sprite) ->
    sprite.body.setCollisionGroup @collisionGroup
    @collisionSpecs.forEach (collision) ->
      sprite.body.collides collision.group, collision.callback, collision.context
