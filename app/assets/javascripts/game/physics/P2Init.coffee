#= require game/physics/prolog

class global8ball.physics.P2Init
  # @param {global8ball.config.GameConfig} gameConfig
  constructor: (@gameConfig) ->

  # Initializes Phaser P2 physics.
  #
  # @param {Phaser.Physics.P2}
  init: (physics) ->
    physics.startSystem Phaser.Physics.P2JS
    physics.p2.restitution = 0.99999
    physics.p2.applyGravity = no
    physics.p2.applySpringForces = no
    physics.p2.setImpactEvents on
    physics.p2.world.solver.tolerance = 0
    physics.p2.world.solver.iterations = 5
    physics.p2.frameRate = 1 / 128

  # Applies contact materials.
  #
  # @param {Phaser.Physics.P2}
  applyContactMaterials: (physics) ->
    ballMaterial = @gameConfig.getBallMaterial()
    borderMaterial = @gameConfig.getBorderMaterial()

    ballBallContactMaterialOptions =
      restitution: @gameConfig.getTable().getBallBallRestitution()
      stiffness: @gameConfig.getTable().getBallBallStiffness()

    physics.p2.addContactMaterial new Phaser.Physics.P2.ContactMaterial ballMaterial, ballMaterial, ballBallContactMaterialOptions

    ballBorderContactMaterialOptions =
      restitution: @gameConfig.getTable().getBallBorderRestitution()
      stiffness: @gameConfig.getTable().getBallBorderStiffness()

    physics.p2.addContactMaterial new Phaser.Physics.P2.ContactMaterial ballMaterial, borderMaterial, ballBorderContactMaterialOptions
