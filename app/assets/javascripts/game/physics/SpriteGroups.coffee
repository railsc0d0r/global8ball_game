#= require game/physics/SpriteGroups

class global8ball.SpriteGroups
  constructor: (@gameObjectFactory, @p2Physics, @collisionCallbackContext, @spriteGroupSpecs, @spriteClasses) ->
    @spriteGroups = {}
    @collisionGroups = {}
    @physicsGroups = {}

  create: ->
    @createSpriteGroups()
    @createCollisionGroups()
    @createPhysicsGroups()
    spriteGroups: @spriteGroups
    collisionGroups: @collisionGroups
    physicsGroups: @physicsGroups

  createSpriteGroups: ->
    for specId, spec of @spriteGroupSpecs
      if not @spriteGroups[spec.spriteGroupId] # Create sprite group only if it does not exist yet!
        group = @gameObjectFactory.group()
        group.classType = @spriteClasses[spec.spriteGroupId] or Phaser.Sprite
        # Enable physics for *all* sprite groups.
        group.enableBody = true
        group.physicsBodyType = Phaser.Physics.P2JS
        @spriteGroups[spec.spriteGroupId] = group

  createCollisionGroups: ->
    for specId of @spriteGroupSpecs
      @collisionGroups[specId] ?= @p2Physics.createCollisionGroup()

  createPhysicsGroups: ->
    for specId, spec of @spriteGroupSpecs
      @physicsGroups[specId] = new global8ball.SpriteGroup spec.spriteKey, @spriteGroups[spec.spriteGroupId], @collisionGroups[spec.collisionGroupId]
      (spec.collides or []).forEach (collision) =>
        if collision.callback
          @physicsGroups[specId].collides @collisionGroups[collision.groupId], @collisionCallbackContext[collision.callback], @collisionCallbackContext
        else
          @physicsGroups[specId].collides @collisionGroups[collision.groupId]
