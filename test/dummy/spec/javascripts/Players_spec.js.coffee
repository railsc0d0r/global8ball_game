#= require game/Players

createPlayers = global8ball.Players.create

describe 'Players', () ->

  it 'exposes the viewer', () ->
    playersData =
      first:
        id: 'first'
        name: 'First'
      second:
        id: 'second'
        name: 'Second'
    viewersData =
      id: 'someone'
      name: 'Someone'

    players = createPlayers playersData, viewersData

    expect(players.getViewer().getName()).to.equal 'Someone'

  it 'exposes the players ordered as given when viewer is none of the players', () ->
    playersData =
      first:
        id: '1st'
        name: 'Number 1'
      second:
        id: '2nd'
        name: 'Number 2'
    viewersData =
      id: 'unrelated',
      name: 'An unrelated person'

    players = createPlayers playersData, viewersData

    expect(players.getFirst().getName()).to.equal 'Number 1'
    expect(players.getSecond().getName()).to.equal 'Number 2'

  it 'swaps players when the viewer is the second player', () ->
    playersData =
      first:
        id: 'no-2'
        name: '# 2'
      second:
        id: 'no-1'
        name: '# 1'
    viewersData =
      id: 'no-1'
      name: '# 1'

    players = createPlayers playersData, viewersData

    expect(players.getFirst().getName()).to.equal '# 1'
    expect(players.getSecond().getName()).to.equal '# 2'
