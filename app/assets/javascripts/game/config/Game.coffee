#= require game/config/prolog

class global8ball.config.Game
  # @param {object} config
  constructor: (@config) ->

  getPhysicsConfig: ->
    cfg = @config
    mpx: (v) ->
      v * cfg.table.scaling_factor
    mpxi: (v) ->
      v * -(cfg.table.scaling_factor)
    pxm: (v) ->
      v / cfg.table.scaling_factor
    pxmi: (v) ->
      v / -(cfg.table.scaling_factor)

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
    convertMeterToPx = @config.physicsConfig.mpx

    Object.keys(borders).map (key, index) ->
      points = []
      for point of borders[key]
        phaserPoint = center.clone().add convertMeterToPx(borders[key][point].x), convertMeterToPx(borders[key][point].y)
        points.push(phaserPoint)
      borders[key] = points
    return borders
