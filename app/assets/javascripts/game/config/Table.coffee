#= require game/config/prolog

class global8ball.config.Table
  constructor: (data) ->
    @borderBounce = Number data.border_bounce
    @tableFriction = Number data.table_friction
    @cueHardness = Number data.cue_hardness
    @maxBreakballSpeed = Number data.max_breakball_speed
