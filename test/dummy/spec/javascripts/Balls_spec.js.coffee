#= require game/config/Balls

describe 'Balls config', ->

  # Shortcut
  BallsConfig = global8ball.config.Balls

  it 'returns empty lists of ball configs when no ball data is available', ->
    ballsConfig = new BallsConfig []

    expect(ballsConfig.getBreakBallsConfig()).toEqual []
    expect(ballsConfig.getPlayBallsConfig()).toEqual []
    expect(ballsConfig.get8BallConfig()).toEqual undefined
