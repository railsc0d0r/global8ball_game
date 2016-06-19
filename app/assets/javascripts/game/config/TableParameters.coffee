#= require game/config/prolog

class global8ball.config.TableParameters
  constructor: (params) ->
    @borderBounce = Number params.border_bounce
    @tableFriction = Number params.table_friction
    @cueHardness = Number params.cue_hardness
