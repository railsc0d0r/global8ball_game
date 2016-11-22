#= require game/advices/prolog

class global8ball.advices.ChangeBreakerAdvice
  constructor: (@ballId) ->

  @create = (event) ->
    new global8ball.advices.ChangeBreakerAdvice event.ball_id
