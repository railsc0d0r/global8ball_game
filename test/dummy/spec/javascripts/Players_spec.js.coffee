#= require game/Players

createPlayers = global8ball.Players.create

describe 'Players', () ->

  playersData =
    first:
      id: 'first'
      name: 'First'
    second:
      id: 'second'
      name: 'Second'
  thirdAccount =
    id: 'third'
    name: 'Third'

  it 'exposes the viewer', () ->
    players = createPlayers playersData, thirdAccount

    expect(players.getViewer().getName()).to.equal thirdAccount.name

  it 'exposes the players ordered as given when viewer is none of the players', () ->
    players = createPlayers playersData, thirdAccount

    expect(players.getFirst().getName()).to.equal playersData.first.name
    expect(players.getSecond().getName()).to.equal playersData.second.name

  it 'swaps players when the viewer is the second player', () ->
    players = createPlayers playersData, playersData.second

    expect(players.getFirst().getName()).to.equal playersData.second.name
    expect(players.getSecond().getName()).to.equal playersData.first.name

  it 'exposes if the viewer is one of the players', () ->
    players = createPlayers playersData, playersData.first

    expect(players.viewerPlays()).to.be.ok

  it 'exposes if the viewer is not one of the players', () ->
    players = createPlayers playersData, thirdAccount

    expect(players.viewerPlays()).to.not.be.ok
