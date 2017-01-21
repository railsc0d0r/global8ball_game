#= require game/config/prolog

class global8ball.config.Table
  toStiffness = (rawStiffness) ->
    if typeof rawStiffness is 'string' and rawStiffness.toLowerCase() is "infinity"
      +Infinity
    else
      rawStiffness

  constructor: (@data) ->
    @ballBallStiffness = toStiffness @data.contact_materials.ball_ball.stiffness
    @ballBorderStiffness = toStiffness @data.contact_materials.ball_border.stiffness

  getDamping: ->
    @data.damping

  getMaximumBreakballSpeed: ->
    @data.max_breakball_speed

  getBallBallStiffness: ->
    @ballBallStiffness

  getBallBorderStiffness: ->
    @ballBorderStiffness

  getBallBallRestitution: ->
    @data.contact_materials.ball_ball.restitution

  getBallBorderRestitution: ->
    @data.contact_materials.ball_border.restitution
