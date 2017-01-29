#= require game/config/prolog
#= require game/config/Table

# Game configuration class. Wraps the game config 'struct' and exposes them
# in a more usable manner.
class global8ball.config.Game
  # @param {object} config
  constructor: (@config) ->

  getPhysicsConfig: ->
    scalingFactor = @config.table.scaling_factor
    mpx: (v) ->
      v * scalingFactor
    mpxi: (v) ->
      v * -scalingFactor
    pxm: (v) ->
      v / scalingFactor
    pxmi: (v) ->
      v / -scalingFactor

  # Returns holes positions.
  holesData: (size) ->
    center = new Phaser.Point size.width / 2, size.height / 2

    holes = {}
    convertMeterToPx = @getPhysicsConfig().mpx

    Object.keys(@config.holes).map (key, index) =>
      currentHoleConfig = @config.holes[key]
      holes[key] =
        pos: center.clone().add convertMeterToPx(currentHoleConfig.x), convertMeterToPx(currentHoleConfig.y)
        radius: convertMeterToPx currentHoleConfig.radius

    return holes

  # There are six borders, they are located between the holes.
  borderData: (size) ->
    center = new Phaser.Point size.width / 2, size.height / 2

    borders = @config.borders
    convertMeterToPx = @getPhysicsConfig().mpx

    Object.keys(borders).map (key, index) ->
      points = []
      for point of borders[key]
        phaserPoint = center.clone().add convertMeterToPx(borders[key][point].x), convertMeterToPx(borders[key][point].y)
        points.push(phaserPoint)
      borders[key] = points
    return borders

  getPlayerData: ->
    first:
      id: @config.player_1.user_id
      name: @config.player_1.name
    second:
      id: @config.player_2.user_id
      name: @config.player_2.name

  getCurrentViewerData: ->
    id: @config.current_viewer.user_id
    name: @config.current_viewer.name

  # @return {global8ball.config.Table}
  getTable: ->
    new global8ball.config.Table @config.table

  # @return {Phaser.Physics.P2.Material}
  getBallMaterial: ->
    @ballMaterial = @ballMaterial ? new Phaser.Physics.P2.Material 'ball'
    return @ballMaterial

  # return {Phaser.Physics.P2.Material}
  getBorderMaterial: ->
    @borderMaterial = @borderMaterial ? new Phaser.Physics.P2.Material 'border'
    return @borderMaterial
