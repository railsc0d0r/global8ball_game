#= require game/Game

Account = global8ball.Account
Player = global8ball.Player
CurrentPlayers = global8ball.config.CurrentPlayers

describe 'CurrentPlayers', ->

  currentPlayers = new CurrentPlayers [ { user_id: 5 }, { user_id: 15 } ]

  it 'contains players when their user ID is one of the current players', ->

    player = new Player new Account(15, "Myself"), false
    expect(currentPlayers.contains player).toBeTruthy()

  it 'does not contain a player whose user ID is not one of the current players', ->

    player = new Player new Account(10, "Someone"), false
    expect(currentPlayers.contains player).toBeFalsy()
