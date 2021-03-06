#= require game/Controls
#= require game/mixinStateEvents
#= require thirdparty/phaser

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
          events:
            onInputDown:
              add: () ->
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

  state = null

  beforeEach () ->
    state = global8ball.mixinStateEvents createMockState()
    controls = new global8ball.Controls
    controls.attach state
    state.create()

  it 'aims the cue on clicking', () ->
    state.input.onDown.dispatch { x: 100, y: 200 }
    state.update()

    expect(state.aims).toEqual jasmine.any(Array)
    expect(state.aims.length).toBeGreaterThan 0
    expect(state.aims[0]).toEqual x: 100, y: 200

  it 'stops aiming the cue when pointer button is not held down', () ->
    pointer = { x: 100, y: 200, isDown: false }

    state.input.onDown.dispatch pointer
    state.update()
    pointer.x = 150
    pointer.y = 250
    state.input.moveCallbacks.forEach (callback) -> callback pointer, pointer.x, pointer.y
    state.update()

    expect(state.aims.length).toEqual 1

  it 'continues aiming the cue when pointer button is held down', () ->
    pointer = { x: 100, y: 200, isDown: true }

    state.input.onDown.dispatch pointer
    state.update()
    pointer.x = 150
    pointer.y = 250
    state.input.moveCallbacks.forEach (callback) -> callback pointer, pointer.x, pointer.y
    state.update()

    expect(state.aims.length).toEqual 2
    expect(state.aims[1]).toEqual x: 150, y: 250
