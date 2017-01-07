#= require game/config/prolog

class global8ball.config.Game
  # @param {Phaser.Game} game
  # @param {object} config
  constructor: (@game, @config) ->

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
  holesData: ->
    center = new Phaser.Point @game.width / 2, @game.height / 2

    holes = {}
    convertMeterToPx = @config.physicsConfig.mpx

    Object.keys(@config.holes).map (key, index) =>
      currentHoleConfig = @config.holes[key]
      holes[key] =
        pos: center.clone().add convertMeterToPx(currentHoleConfig.x), convertMeterToPx(currentHoleConfig.y)
        radius: currentHoleConfig.radius

    return holes

  # There are six borders, they are located between the holes.
  borderData: ->
    center = new Phaser.Point @game.width / 2, @game.height / 2

    borders = @config.borders
    convertMeterToPx = @config.physicsConfig.mpx

    Object.keys(borders).map (key, index) ->
      points = []
      for point of borders[key]
        phaserPoint = center.clone().add convertMeterToPx(borders[key][point].x), convertMeterToPx(borders[key][point].y)
        points.push(phaserPoint)
      borders[key] = points
    return borders
