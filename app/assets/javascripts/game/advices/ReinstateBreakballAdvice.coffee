#= require game/advices/prolog

class global8ball.advices.ReinstateBreakballAdvice
  constructor: (@ballId) ->

  @create = (event) ->
    new global8ball.advices.ReinstateBreakballAdvice event.ball_id
