#= require game/advices/prolog

class global8ball.advices.RoundLostAdvice
  constructor: (@ballId) ->

  @create = (event) ->
    new global8ball.advices.RoundLostAdvice event.ball_id
