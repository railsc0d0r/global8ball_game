#= require game/sprites/Border
#= require game/sprites/Hole
#= require game/mixinStateEvents
#= require game/physics/SpriteGroup
#= require game/physics/SpriteGroups
#= require game/prolog

# Base class for all full Phaser states (i.e. with all images etc.)
class global8ball.FullState extends Phaser.State
  # @param {global8ball.config.Game} gameConfig
  # @param {global8ball.Players} players
  constructor: (@gameConfig, @players) ->
    global8ball.mixinStateEvents @

  addGroup: (groupName) ->
    @collisionGroups[groupName] ?= @physics.p2.createCollisionGroup()
    if not @spriteGroups[groupName]
      @spriteGroups[groupName] = @add.group()

  init: () ->
    @spriteGroups = {}
    @collisionGroups = {}
    @physicsGroups = {}

  create: ->
    spriteGroups = new global8ball.SpriteGroups @add, @physics.p2, @, @getPhysicsGroupSpecs(), @spriteClasses()
    groups = spriteGroups.create()
    @spriteGroups = groups.spriteGroups
    @collisionGroups = groups.collisionGroups
    @physicsGroups = groups.physicsGroups
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

  # @return {Object.<string, function>} Map of classes
  spriteClasses: () ->
    borders: global8ball.Border
    holes: global8ball.Hole

  createBorders: ->
    bordersData = @gameConfig.borderData @game
    for borderKey of bordersData
      borderData = bordersData[borderKey]
      config =
        borderKey: borderKey
        static: yes
        visible: no

      poly = new Phaser.Polygon(borderData)

      setBorderBody = (body) =>
        body.static = true
        body.addPolygon {}, borderData.map (point) -> [point.x, point.y]
        body.setMaterial @gameConfig.getBorderMaterial()

      border = @createSprite 'borders', 0, 0, config, setBorderBody

    @spriteGroups.borders

  createHoles: ->
    holesData = @gameConfig.holesData @game
    @holes = (@createHole key, holesData[key] for key of holesData)

  # @return {Hole}
  createHole: (key, holeData) ->
    createHoleBody = (body) ->
      body.clearShapes()
      body.addCircle holeData.radius, 0, 0, 0
      body.static = true # Holes are immobile
    sprite = @createSprite 'holes', holeData.pos.x, holeData.pos.y, { holeKey: key }, createHoleBody
    sprite.anchor.setTo 0.5, 0.5
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

  getSprites: (predicate) ->
    foundSprites = []
    currentChildren = @world.children.concat()
    while currentChildren.length > 0
      child = currentChildren.shift()
      if child.type is Phaser.SPRITE && predicate child
        foundSprites.push child
      if child.type is Phaser.GROUP
        currentChildren = currentChildren.concat child.children
    return foundSprites

  getSprite: (predicate) ->
    sprites = @getSprites predicate
    return sprites[0]
