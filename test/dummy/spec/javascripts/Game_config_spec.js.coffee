#= require game/config/Game

describe 'Game config', ->

  GameConfig = global8ball.config.Game

  createConfig = ->
    borders:
      left: [
        {
          x: -1.25
          y: 0.55
        },
        {
          x: -1.25,
          y: -0.55
        },
        {
          x: -1.3,
          y: -0.6
        },
        {
          x: -1.3,
          y: 0.6
        }
      ]
      leftBottom: [
        {
          x: -1.25,
          y: 0.7
        },
        {
          x: 0,
          y: 0.7
        },
        {
          x: 0,
          y: 0.6
        },
        {
          x: -1.2,
          y: 0.6
        }
      ]
      leftTop: [
        {
          x: 0,
          y: -0.7
        },
        {
          x: -1.2,
          y: -0.7
        },
        {
          x: -1.2,
          y: -0.6
        },
        {
          x: 0,
          y: -0.6
        }
      ]
      right: [
        {
          x: 1.3,
          y: 0.6
        },
        {
          x: 1.3,
          y: -0.6
        },
        {
          x: 1.25,
          y: -0.5
        },
        {
          x: 1.25,
          y: 0.55
        }
      ]
      rightBottom: [
        {
          x: 0,
          y: 0.7
        },
        {
          x: 1.25,
          y: 0.7
        },
        {
          x: 1.2,
          y: 0.6
        },
        {
          x: 0.1,
          y: 0.6
        }
      ]
      rightTop: [
        {
          x: 1.25,
          y: -0.7
        },
        {
          x: 0,
          y: -0.7
        },
        {
          x: 0.1,
          y: -0.6
        },
        {
          x: 1.2,
          y: -0.6
        }
      ]
    current_viewer:
      name: ""
      user_id: 1
    holes:
      centerBottom:
        radius: 0.01
        x: -0.2
        y: 0.6
      centerTop:
        radius: 0.01
        x: -0.2
        y: 0.6
      leftBottom:
        radius: 0.01
        x: -0.2
        y: 0.6
      leftTop:
        radius: 0.01
        x: -0.2
        y: 0.6
      rightBottom:
        radius: 0.01
        x: -0.2
        y: 0.6
      rightTop:
        radius: 0.01
        x: -0.2
        y: 0.6
    player_1:
      name: ""
      user_id: 1
    player_2:
      name: ""
      user_id: 2
    table:
      contact_materials:
        ball_ball:
          restitution: 0.9
          stiffness: "INFINITY"
        ball_border:
          restitution: 0.95
          stiffness: "INFINITY"
      damping: 0.2
      max_breakball_speed: 10
      min_ball_speed: 0.01
      scaling_factor: 400

  it 'provides an mpx converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 300

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.mpx 2
    expect(scaledValue).toEqual 600

  it 'provides an mpxi converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 400

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.mpxi 0.5
    expect(scaledValue).toEqual -200

  it 'provides an pxm converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 250

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.pxm 125
    expect(scaledValue).toEqual 0.5

  it 'provides an pxmi converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 350

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.pxmi 700
    expect(scaledValue).toEqual -2

  it 'provides converted holes data', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 200
    cfg.holes.leftBottom =
      x: -0.8
      y: 0.6
      radius: 0.01

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    leftBottomHole = gameConfig.holesData(width: 1000, height: 800).leftBottom

    expect(leftBottomHole.radius).toEqual 2
    expect(leftBottomHole.pos.x).toEqual 340
    expect(leftBottomHole.pos.y).toEqual 520

  it 'provides converted borders data', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 300
    cfg.borders.left = [
      {
        x: -1
        y: -1
      },
      {
        x: 1
        y: 0.5
      },
      {
        x: -0.5
        y: 1
      }
    ]

    gameConfig = new GameConfig cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    leftBorderPoints = gameConfig.borderData(width: 800, height: 600).left
    expect(leftBorderPoints).toContain new Phaser.Point(100, 0)
    expect(leftBorderPoints).toContain new Phaser.Point(700, 450)
    expect(leftBorderPoints).toContain new Phaser.Point(250, 600)
