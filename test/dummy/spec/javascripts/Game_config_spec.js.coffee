#= require game/config/Game

describe 'Game config', ->

  GameConfig = global8ball.config.Game

  createConfig = ->
    borders:
      left: [
        {
          x: 120
          y: 600
        },
        {
          x: 120,
          y: 180
        },
        {
          x: 100,
          y: 160
        },
        {
          x: 100,
          y: 600
        }
      ]
      leftBottom: [
        {
          x: 125,
          y: 600
        },
        {
          x: 580,
          y: 600
        },
        {
          x: 575,
          y: 600
        },
        {
          x: 150,
          y: 600
        }
      ]
      leftTop: [
        {
          x: 580,
          y: 140
        },
        {
          x: 125,
          y: 140
        },
        {
          x: 150,
          y: 160
        },
        {
          x: 575,
          y: 160
        }
      ]
      right: [
        {
          x: 1100,
          y: 635
        },
        {
          x: 1100,
          y: 165
        },
        {
          x: 1080,
          y: 190
        },
        {
          x: 1080,
          y: 600
        }
      ]
      rightBottom: [
        {
          x: 615,
          y: 660
        },
        {
          x: 1075,
          y: 660
        },
        {
          x: 1050,
          y: 640
        },
        {
          x: 625,
          y: 640
        }
      ]
      rightTop: [
        {
          x: 1075,
          y: 140
        },
        {
          x: 615,
          y: 140
        },
        {
          x: 625,
          y: 160
        },
        {
          x: 1050,
          y: 160
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

    gameConfig = new GameConfig {}, cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.mpx 2
    expect(scaledValue).toEqual 600

  it 'provides an mpxi converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 400

    gameConfig = new GameConfig {}, cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.mpxi 0.5
    expect(scaledValue).toEqual -200

  it 'provides an pxm converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 250

    gameConfig = new GameConfig {}, cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.pxm 125
    expect(scaledValue).toEqual 0.5

  it 'provides an pxmi converter', ->
    cfg = createConfig()
    cfg.table.scaling_factor = 350

    gameConfig = new GameConfig {}, cfg
    physicsConfig = gameConfig.getPhysicsConfig()

    scaledValue = physicsConfig.pxmi 700
    expect(scaledValue).toEqual -2
