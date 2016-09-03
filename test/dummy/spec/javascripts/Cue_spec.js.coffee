#= require game/Game

# Convenience shortcuts
Account = global8ball.Account
Cue = global8ball.Cue
Player = global8ball.Player

describe 'Cue', ->

  createCue = (owner) ->
    cue = new Cue
    cue.body =
      x: 0
      y: 0
      angle: 0
      rotation: 0
      velocity:
        mx: 0
        my: 0
    cue.setOwner owner
    cue.initStates()
    return cue

  it 'is visible when on the table and owner is viewer', ->
    cue = createCue Player.createViewingPlayer new Account 666, 'The Devil'
    cue.putOnTable()
    expect(cue.visible).to.be.ok

  it 'is invisible when not on the table and owner is viewer', ->
    cue = createCue Player.createViewingPlayer new Account 667, "The Devil's Neighbour"
    cue.retreatFromTable()
    expect(cue.visible).to.not.be.ok
