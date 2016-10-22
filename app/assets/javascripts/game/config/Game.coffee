#= require game/config/prolog

class global8ball.config.Game
  constructor: (@game, @config) ->

  # Returns holes positions.
  holesData: ->
    center = new Phaser.Point @game.width / 2, @game.height / 2

    holes = @config.holes
    convertMeterToPx = @config.physicsConfig.mpx

    Object.keys(holes).map (key, index) ->
      holes[key] = pos: center.clone().add convertMeterToPx(holes[key].x), convertMeterToPx(holes[key].y)

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