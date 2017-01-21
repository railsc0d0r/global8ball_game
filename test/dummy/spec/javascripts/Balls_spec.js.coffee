#= require game/config/Balls

describe 'Balls config', ->

  # Shortcut
  BallsConfig = global8ball.config.Balls

  it 'returns empty lists of ball configs when no ball data is available', ->
    ballsConfig = new BallsConfig []

    expect(ballsConfig.getBreakBallsConfig()).toEqual []
    expect(ballsConfig.getPlayBallsConfig()).toEqual []
    expect(ballsConfig.get8BallConfig()).toEqual undefined

  it 'returns a breakball as breakball', ->
    ballsConfig = new BallsConfig [
      {
        color: "white"
        id: 37
        mass: 0.17
        owner: "666"
        radius: 0.0291
        type: "breakball"
        position:
          x: -0.5
          y: -0.25
      }
    ]

    expect(ballsConfig.getBreakBallsConfig().length).toEqual 1
    expect(ballsConfig.getPlayBallsConfig()).toEqual []
    expect(ballsConfig.get8BallConfig()).toEqual undefined

  it 'returns a playball as playball.', ->
    ballsConfig = new BallsConfig [
      {
        color: "red"
        id: 38
        mass: 0.175
        owner: "666"
        radius: 0.0292
        type: "playball"
        position:
          x: -0.25
          y: -0.5
      }
    ]

    expect(ballsConfig.getBreakBallsConfig()).toEqual []
    expect(ballsConfig.getPlayBallsConfig().length).toEqual 1
    expect(ballsConfig.get8BallConfig()).toEqual undefined

  it 'returns the 8ball as 8ball.', ->
    ballsConfig = new BallsConfig [
      {
        color: "black"
        id: 38
        mass: 0.175
        radius: 0.0292
        type: "8ball"
        position:
          x: -0.25
          y: -0.5
      }
    ]

    expect(ballsConfig.getBreakBallsConfig()).toEqual []
    expect(ballsConfig.getPlayBallsConfig()).toEqual []
    expect(ballsConfig.get8BallConfig()).not.toEqual undefined
