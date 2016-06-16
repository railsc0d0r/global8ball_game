#= require game/prolog
#= require game/phaser

class global8ball.Cue extends Phaser.Sprite
  # Default distance to ball.
  DEFAULT_DISTANCE_TO_BALL = 20

  MATH_FACTOR = Math.PI/180

  power: 0
  targetBall: null
  distanceToBall: null

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

  # @param {Point} Position to aim at. The cue will point TO that position, not FROM it!
  setAngleByAim: (pos) ->
    if @targetBall
      @setAngle Math.atan2(@targetBall.body.y - pos.y, @targetBall.body.x - pos.x) / MATH_FACTOR

  updatePosition: ()->
    if @targetBall
      @body.x = @targetBall.x + @getOffsetToBall() * Math.cos(MATH_FACTOR * @body.angle)
      @body.y = @targetBall.y + @getOffsetToBall() * Math.sin(MATH_FACTOR * @body.angle)

  # Set distance between cue and ball. Can also be set to null, which means the default value is used.
  #
  # @param {number} distance
  setDistanceToBall: (@distanceToBall) ->

  # @return {number}
  getOffsetToBall: () ->
    @width / 2 + if typeof @distanceToBall is 'number' then @distanceToBall else DEFAULT_DISTANCE_TO_BALL
