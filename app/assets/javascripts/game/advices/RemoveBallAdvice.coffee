#= require game/advices/prolog

class global8ball.advices.RemoveBallAdvice
  constructor: (@ballId) ->

  @create = (event) ->
    new global8ball.advices.RemoveBallAdvice event.ball_id
