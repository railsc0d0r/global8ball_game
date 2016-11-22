#= require game/prolog

class global8ball.AdviceFactory
  constructor:
    @creators = {}

  addCreator: (type, creator) ->
    @creators[type] = creator

  createAdvice: (event) ->
    if @creators[event.advice]
      @creators[event.advice](event)
