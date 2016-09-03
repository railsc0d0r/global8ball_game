#= require game/Game

# Convenience shortcuts
Account = global8ball.Account
Cue = global8ball.Cue
Player = global8ball.Player

describe 'Cue', ->

  chai.util.addProperty chai.Assertion.prototype, 'visible', () ->
    @assert(
      @._obj.visible
      'Expected #{this} to be visible'
      'Expected #{this} to be invisible'
    )

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
    expect(cue).to.be.visible

  it 'is invisible when not on the table and owner is viewer', ->
    cue = createCue Player.createViewingPlayer new Account 667, "The Devil's Neighbour"
    cue.retreatFromTable()
    expect(cue).not.to.be.visible
