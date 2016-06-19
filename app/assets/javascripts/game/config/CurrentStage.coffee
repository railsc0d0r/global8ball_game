#= require game/config/prolog

class global8ball.config.CurrentStage
  constructor: (data) ->
    @stageName = data.stage_name
    @round = new global8ball.config.Round data.round
