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
      moveCallbacks: []
      addMoveCallback: (callback) ->
        @moveCallbacks.push callback
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

  it 'stops aiming the cue when pointer button is not held down', () ->
    state = global8ball.mixinStateEvents createMockState()
    controls = new global8ball.Controls
    controls.attach state
    pointer = { x: 100, y: 200, isDown: false }

    state.create()
    state.input.onDown.dispatch pointer
    state.update()
    state.update()

    expect(state.aims.length).to.equal 1

  it 'continues aiming the cue when pointer button is held down', () ->
    state = global8ball.mixinStateEvents createMockState()
    controls = new global8ball.Controls
    controls.attach state
    pointer = { x: 100, y: 200, isDown: true }

    state.create()
    state.input.onDown.dispatch pointer
    state.update()
    pointer.x = 150
    pointer.y = 250
    state.input.moveCallbacks.forEach (callback) -> callback pointer, pointer.x, pointer.y
    state.update()

    expect(state.aims.length).to.equal 2
    expect(state.aims[1]).to.deep.equal x: 150, y: 250
