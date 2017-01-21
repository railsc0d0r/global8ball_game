#= require game/prolog
#= require game/physics/P2Init

# The first state. Contains only minor initializations and everything necessary
# to start the next state, Preload.
class global8ball.Boot extends Phaser.State
  # @param {global8ball.config.Game} gameConfig
  # @param {global8ball.Game} g8bGame
  constructor: (@gameConfig, @g8bGame)->

  preload: ->
    @game.stage.disableVisibilityChange = true
    @g8bGame.overloadImageLoading()
    @g8bGame.makeTextsTranslatable()
    @game.load.image 'preloader-bar', 'game/preloader_bar.png'

  create: ->
    @game.stage.backgroundColor = '#000000'
    @game.state.start 'Preload'
    @game.scale.setGameSize 1200, 800
    @game.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    physicsInit = new global8ball.physics.P2Init @gameConfig
    physicsInit.init(@physics)
