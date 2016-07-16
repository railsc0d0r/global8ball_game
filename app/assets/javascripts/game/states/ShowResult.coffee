#= require game/prolog
#= require game/states/FullState

# State for showing results after the state is over.
class global8ball.ShowResult extends global8ball.FullState
  constructor: (gameConfig, players) ->
    super gameConfig, players

  init: (@winner) ->
    super()

  create: ->
    super()
    @victoryText = @game.add.text @game.width / 2, 10, {message: 'game.show_victory.win', context: { name: @winner }}
    @victoryText.anchor.setTo 0.5, 0
    @victoryText.fill = '#ffffff'
