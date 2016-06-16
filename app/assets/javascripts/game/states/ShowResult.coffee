#= require game/prolog
#= require game/states/FullState

class global8ball.ShowResult extends global8ball.FullState
  constructor: (gameConfig) ->
    super gameConfig

  init: (@winner) ->
    super()

  create: ->
    super()
    @victoryText = @game.add.text @game.width / 2, 10, {message: 'game.show_victory.win', context: { name: @winner }}
    @victoryText.anchor.setTo 0.5, 0
    @victoryText.fill = '#ffffff'
