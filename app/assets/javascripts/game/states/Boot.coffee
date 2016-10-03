#= require game/prolog

# The first state. Contains only minor initializations and everything necessary
# to start the next state, Preload.
class global8ball.Boot extends Phaser.State
  constructor: (@g8bGame)->

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
    @physics.startSystem Phaser.Physics.P2JS
    @physics.p2.restitution = 0.99999
    @physics.p2.applyGravity = no
    @physics.p2.applySpringForces = no
    @physics.p2.setImpactEvents on
    @physics.p2.world.solver.tolerance = 0
    @physics.p2.world.solver.iterations = 1000
