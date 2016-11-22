#= require game/advices/prolog

class global8ball.advices.RoundWonAdvice
  constructor: (@ballId) ->

  @create = (event) ->
    new global8ball.advices.RoundWonAdvice event.ball_id
