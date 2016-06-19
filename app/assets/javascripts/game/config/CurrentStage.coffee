#= require game/config/prolog
#= require game/config/Round

class global8ball.config.CurrentStage
  constructor: (data) ->
    @stageName = data.stage_name
    @round = new global8ball.config.Round data.round
