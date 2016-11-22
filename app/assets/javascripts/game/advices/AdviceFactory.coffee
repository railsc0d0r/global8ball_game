#= require game/prolog
#= require game/advices/ChangeBreakerAdvice
#= require game/advices/ReinstateBreakballAdvice
#= require game/advices/RemoveBallAdvice
#= require game/advices/RoundLostAdvice
#= require game/advices/RoundWonAdvice

class global8ball.AdviceFactory
  constructor:
    @creators = {}

  addCreator: (type, creator) ->
    @creators[type] = creator

  createAdvice: (event) ->
    if @creators[event.advice]
      @creators[event.advice](event)

global8ball.AdviceFactory.createDefault = () ->
  factory = new global8ball.AdviceFactory
  factory.addCreator 'change_breaker', global8ball.advices.ChangeBreakerAdvice
  factory.addCreator 'reinstate_breakball', global8ball.advices.ReinstateBreakballAdvice
  factory.addCreator 'remove_ball', global8ball.advices.RemoveBallAdvice
  factory.addCreator 'round_lost', global8ball.advices.RoundLostAdvice
  factory.addCreator 'round_won', global8ball.advices.RoundWonAdvice
  return factory
