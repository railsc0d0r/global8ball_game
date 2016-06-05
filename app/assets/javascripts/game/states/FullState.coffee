#= require game/mixinStateEvents
#= require game/prolog

# Base class for all full Phaser states (i.e. with all images etc.)
class global8ball.FullState extends Phaser.State
  constructor: (@g8bGame) ->
    global8ball.mixinStateEvents @

  addGroup: (collisionGroupName, spriteGroupName = collisionGroupName, spriteClassType = Phaser.Sprite) ->
    @collisionGroups[collisionGroupName] ?= @physics.p2.createCollisionGroup()
    if not @spriteGroups[spriteGroupName]
      @spriteGroups[spriteGroupName] = @add.group()
      @spriteGroups[spriteGroupName].classType = spriteClassType

  init: ->
    @spriteGroups = {}
    @collisionGroups = {}
    @physicsGroups = {}

  create: ->
    @physics.startSystem Phaser.Physics.P2JS
    @physics.p2.restitution = 0.99999
    @physics.p2.setImpactEvents on
    @createSpriteGroups()
    @createCollisionGroups()
    @createPhysicsGroups()
    @addGroup 'table'
    @game.input.maxPointers = 1 # No multi-touch
    @tableFloor = @game.add.image @game.width / 2, @game.height / 2, 'background', `/*frame=*/ undefined`, @spriteGroups.table
    @tableFloor.anchor.setTo 0.5, 0.5
    @table = @game.add.image @game.width / 2, @game.height / 2, 'table'
    @table.anchor.setTo 0.5, 0.5
    @createHoles()
    @createPlayerInfos()
    @borders = @createBorders()
    @world.sendToBack @spriteGroups.table

  createSpriteGroups: () ->
    for specId, spec of @getPhysicsGroupSpecs()
      if not @spriteGroups[spec.spriteGroupId] # Create sprite group only if it does not exist yet!
        group = @add.group()
        group.classType = @spriteClasses()[spec.spriteGroupId] or Phaser.Sprite
        # Enable physics for *all* sprite groups.
        group.enableBody = true
        group.physicsBodyType = Phaser.Physics.P2JS
        @spriteGroups[spec.spriteGroupId] = group

  getPhysicsGroupSpecs: () ->
    borders:
      spriteKey: 'border'
      spriteGroupId: 'borders'
      collisionGroupId: 'borders'
    holes:
      spriteKey: 'hole'
      spriteGroupId: 'holes'
      collisionGroupId: 'holes'

  spriteClasses: () ->
    holes: global8ball.Hole

  createCollisionGroups: () ->
    for specId of @getPhysicsGroupSpecs()
      @collisionGroups[specId] ?= @physics.p2.createCollisionGroup()

  createPhysicsGroups: () ->
    for specId, spec of @getPhysicsGroupSpecs()
      @physicsGroups[specId] = new global8ball.PhysicsGroup spec.spriteKey, @spriteGroups[spec.spriteGroupId], @collisionGroups[spec.collisionGroupId]
      (spec.collides or []).forEach (collision) =>
        if collision.callback
          @physicsGroups[specId].collides @collisionGroups[collision.groupId], @[collision.callback], @
        else
          @physicsGroups[specId].collides @collisionGroups[collision.groupId]

  createBorders: ->
    bordersData = @g8bGame.borderData()
    for borderKey of bordersData
      borderData = bordersData[borderKey]
      config =
        borderKey: borderKey
        height: borderData.size.height
        static: yes
        width: borderData.size.width
        visible: no
      border = @createSprite 'borders', borderData.pos.x, borderData.pos.y, config
      border.body.setRectangleFromSprite border
    @spriteGroups.borders

  createHoles: ->
    holesData = @g8bGame.holesData()
    @holes = (@createHole key, holesData[key] for key of holesData)

  # @return {Hole}
  createHole: (key, holeData) ->
    sprite = @createSprite 'holes', holeData.pos.x, holeData.pos.y, holeKey: key
    sprite.anchor.setTo 0.5, 0.5
    return sprite

  createPlayerInfos: () ->
    you = @game.add.text 20, 30, {message: 'game.player_info.you', context: { name: @g8bGame.getPlayers().getFirst().getName() } }
    you.anchor.setTo 0, 0
    you.fill = '#ffffff'
    enemy = @game.add.text @game.width - 20, 30, {message: 'game.player_info.enemy', context: { name: @g8bGame.getPlayers().getSecond().getName() } }
    enemy.anchor.setTo 1, 0
    enemy.fill = '#ffffff'
    @players =
      you: you
      enemy: enemy

  createSprite: (physicsId, x, y, config = {}) ->
    @physicsGroups[physicsId].create x, y, config
