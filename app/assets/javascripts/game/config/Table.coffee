#= require game/config/prolog

class global8ball.config.Table
  constructor: (@data) ->
    @ballBallStiffness = @data.contact_materials.ball_ball.stiffness
    if typeof @ballBallStiffness is 'string' and @ballBallStiffness.toLowerCase() is "infinity"
      @ballBallStiffness = +Infinity

  getDamping: ->
    @data.damping

  getMaximumBreakballSpeed: ->
    @data.max_breakball_speed

  getBallBallStiffness: ->
    @ballBallStiffness
