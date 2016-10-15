#= require game/sprites/Border
#= require game/sprites/Hole
#= require game/mixinStateEvents
#= require game/physics/SpriteGroup
#= require game/prolog

# Base class for all full Phaser states (i.e. with all images etc.)
class global8ball.FullState extends Phaser.State
  constructor: (@gameConfig, @players) ->
    global8ball.mixinStateEvents @

  addGroup: (collisionGroupName, spriteGroupName = collisionGroupName) ->
    @collisionGroups[collisionGroupName] ?= @physics.p2.createCollisionGroup()
    if not @spriteGroups[spriteGroupName]
      @spriteGroups[spriteGroupName] = @add.group()

  init: () ->
    @spriteGroups = {}
    @collisionGroups = {}
    @physicsGroups = {}

  create: ->
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
    borders: global8ball.Border
    holes: global8ball.Hole

  createCollisionGroups: () ->
    for specId of @getPhysicsGroupSpecs()
      @collisionGroups[specId] ?= @physics.p2.createCollisionGroup()

  createPhysicsGroups: () ->
    for specId, spec of @getPhysicsGroupSpecs()
      @physicsGroups[specId] = new global8ball.SpriteGroup spec.spriteKey, @spriteGroups[spec.spriteGroupId], @collisionGroups[spec.collisionGroupId]
      (spec.collides or []).forEach (collision) =>
        if collision.callback
          @physicsGroups[specId].collides @collisionGroups[collision.groupId], @[collision.callback], @
        else
          @physicsGroups[specId].collides @collisionGroups[collision.groupId]

  createBorders: ->
    bordersData = @gameConfig.borderData()
    for borderKey of bordersData
      borderData = bordersData[borderKey]
      config =
        borderKey: borderKey
        static: yes
        visible: no

      poly = new Phaser.Polygon(borderData)

      setBorderBody = (body) ->
        body.static = true
        body.addPolygon {}, borderData.map (point) -> [point.x, point.y]
        body.ccdSpeedThreshold = 1
        body.ccdIterations = 1000

      border = @createSprite 'borders', 0, 0, config, setBorderBody

    @spriteGroups.borders

  createHoles: ->
    holesData = @gameConfig.holesData()
    @holes = (@createHole key, holesData[key] for key of holesData)

  # @return {Hole}
  createHole: (key, holeData) ->
    sprite = @createSprite 'holes', holeData.pos.x, holeData.pos.y, holeKey: key
    sprite.anchor.setTo 0.5, 0.5
    sprite.body.static = true # Holes are immobile
    return sprite

  createPlayerInfos: () ->
    you = @game.add.text 20, 30, {message: 'game.player_info.you', context: { name: @players.getFirst().getName() } }
    you.anchor.setTo 0, 0
    you.fill = '#ffffff'
    enemy = @game.add.text @game.width - 20, 30, {message: 'game.player_info.enemy', context: { name: @players.getSecond().getName() } }
    enemy.anchor.setTo 1, 0
    enemy.fill = '#ffffff'

  createSprite: (physicsId, x, y, config = {}, bodyModifier = () ->) ->
    @physicsGroups[physicsId].create x, y, config, bodyModifier
