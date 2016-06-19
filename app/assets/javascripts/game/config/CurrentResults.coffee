#= require game/config/prolog
#= require game/config/Round

class global8ball.config.CurrentResults
  constructor: (resultsData) ->
    @results = resultsData.map (resultData) -> new global8ball.config.Result resultData

class global8ball.config.Result
  constructor: (resultData) ->
    @stageName = resultData.stage_name
    @winner = resultData.winner
    @round = new global8ball.config.Round resultData.round
