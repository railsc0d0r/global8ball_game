#= require game/Game

# Convenience shortcuts
Account = global8ball.Account
Cue = global8ball.Cue
Player = global8ball.Player
Shot = global8ball.Shot

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
    expect(cue.visible).toBeTruthy()

  it 'is invisible when not on the table and owner is viewer', ->
    cue = createCue Player.createViewingPlayer new Account 667, "The Devil's Neighbour"
    cue.retreatFromTable()
    expect(cue.visible).toBeFalsy()

  it 'is invisible when on the table and owner is not the viewer', ->
    cue = createCue Player.createNonViewingPlayer new Account 668, "The Devil's distant cousin"
    cue.putOnTable()
    expect(cue.visible).toBeFalsy()

  it 'is invisible when not on the table and owner is not the viewer', ->
    cue = createCue Player.createNonViewingPlayer new Account 669, "The Devil's even more distant cousin"
    cue.retreatFromTable()
    expect(cue.visible).toBeFalsy()

  it 'is visible when shooting, even if owner is not the viewer', ->
    cue = createCue Player.createNonViewingPlayer new Account 670, "The Devil's random relative"
    cue.putOnTable()
    cue.shoot new Shot user_id: 670, strength: 1, angle: 0
    expect(cue.visible).toBeTruthy()

  it 'is invisible after shooting, then retrating from table, even for the viewer', ->
    cue = createCue Player.createViewingPlayer new Account 671, "The Devil's very distant friend"
    cue.putOnTable()
    cue.shoot new Shot user_id: 671, strength: 1, angle: 0
    cue.retreatFromTable()
    expect(cue.visible).toBeFalsy()

  it 'ignores shots not done by the ower', ->
    cue = createCue Player.createNonViewingPlayer new Account 42, "Mouse"
    cue.putOnTable()
    cue.shoot new Shot user_id: 43, strength: 1, angle: 0
    expect(cue.body.velocity.mx).toEqual 0
    expect(cue.body.velocity.my).toEqual 0
