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
    current_viewer:
      name: ""
      user_id: 1
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

  describe 'Physics config', ->

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

  it 'provides player configs', ->
    cfg = createConfig()
    cfg.player_1 =
      user_id: 33
      name: "Kunta Kinte"
    cfg.player_2 =
      user_id: 666
      name: "NOT the devil"

    gameConfig = new GameConfig cfg
    playerData = gameConfig.getPlayerData()

    expect(playerData.first.id).toEqual 33
    expect(playerData.first.name).toEqual "Kunta Kinte"
    expect(playerData.second.id).toEqual 666
    expect(playerData.second.name).toEqual "NOT the devil"

  it 'provides current viewer data', ->
    cfg = createConfig()
    cfg.current_viewer =
      user_id: 42
      name: "Mysterious Man"

    gameConfig = new GameConfig cfg
    currentViewerData = gameConfig.getCurrentViewerData()

    expect(currentViewerData.id).toEqual 42
    expect(currentViewerData.name).toEqual "Mysterious Man"

  describe 'Table config', ->

    it 'exposes table damping', ->
      cfg = createConfig()
      cfg.table.damping = 0.1

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getDamping()).toEqual 0.1

    it 'exposes maximum breakball speed', ->
      cfg = createConfig()
      cfg.table.max_breakball_speed = 12

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getMaximumBreakballSpeed()).toEqual 12

    it 'exposes ball/ball stiffness', ->
      cfg = createConfig()
      cfg.table.contact_materials.ball_ball.stiffness = 0.8

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getBallBallStiffness()).toEqual 0.8

    it 'exposes infinite ball/ball stiffness', ->
      cfg = createConfig()
      cfg.table.contact_materials.ball_ball.stiffness = 'InfiNity'

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getBallBallStiffness()).toEqual +Infinity

    it 'exposes ball/border stiffness', ->
      cfg = createConfig()
      cfg.table.contact_materials.ball_border.stiffness = 0.75

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getBallBorderStiffness()).toEqual 0.75

    it 'exposes infinite ball/border stiffness', ->
      cfg = createConfig()
      cfg.table.contact_materials.ball_border.stiffness = 'inFinitY'

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getBallBorderStiffness()).toEqual +Infinity

    it 'exposes ball/ball restitution', ->
      cfg = createConfig()
      cfg.table.contact_materials.ball_ball.restitution = 0.75

      gameConfig = new GameConfig cfg

      expect(gameConfig.getTable().getBallBallRestitution()).toEqual 0.75
