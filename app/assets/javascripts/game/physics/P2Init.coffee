#= require game/physics/prolog

class global8ball.physics.P2Init
  # @param {global8ball.config.GameConfig} gameConfig
  constructor: (@gameConfig) ->

  # Initializes Phaser P2 physics.
  #
  # @param {}
  init: (physics) ->
    physics.startSystem Phaser.Physics.P2JS
    physics.p2.restitution = 0.99999
    physics.p2.applyGravity = no
    physics.p2.applySpringForces = no
    physics.p2.setImpactEvents on
    physics.p2.world.solver.tolerance = 0
    physics.p2.world.solver.iterations = 5
    physics.p2.frameRate = 1 / 128
