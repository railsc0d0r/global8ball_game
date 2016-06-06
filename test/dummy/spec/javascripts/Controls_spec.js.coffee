#= require game/Controls
#= require game/mixinStateEvents
#= require game/phaser

describe 'Game controls', () ->

  createMockState = () ->
    game:
      width: 800
      height: 600
      add:
        sprite: () ->
          anchor:
            setTo: () ->
          events:
            onInputOver: new Phaser.Signal
            onInputOut: new Phaser.Signal
            onInputDown: new Phaser.Signal
          animations:
            frame: 0
        graphics: () ->
          beginFill: () ->
          clear: () ->
          drawRect: () ->
    input:
      onDown: new Phaser.Signal
      onUp: new Phaser.Signal
      addMoveCallback: () ->
    create: () ->
    update: () ->
    shutdown: () ->
    aims: []
    aimAt: (x, y) ->
      @aims.push x: x, y: y

  it 'aims the cue on clicking', () ->
    state = global8ball.mixinStateEvents createMockState()
    controls = new global8ball.Controls
    controls.attach state

    state.create()
    state.input.onDown.dispatch { x: 100, y: 200 }
    state.update()

    expect(state.aims).to.not.be.empty
    expect(state.aims[0]).to.deep.equal x: 100, y: 200
