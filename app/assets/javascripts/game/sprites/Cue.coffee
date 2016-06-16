#= require game/prolog
#= require game/phaser

class global8ball.Cue extends Phaser.Sprite
  LENGTH = 250
  MATH_FACTOR = Math.PI/180

  power: 0
  targetBall: null

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
      @body.x = @targetBall.x + LENGTH * Math.cos(MATH_FACTOR * @body.angle)
      @body.y = @targetBall.y + LENGTH * Math.sin(MATH_FACTOR * @body.angle)
