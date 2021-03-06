#= require game/Game

describe 'Game', ->

  it 'is provided', ->
    expect(global8ball).toBeDefined()
    expect(global8ball.Game).toBeDefined()

describe 'Overload', ->

  it "switches an object's method to a new one", ->
    overload = new global8ball.Game.Overload
    original =
      action: () -> 'Original'
    overload.overload original, 'action', () -> () -> 'New'
    expect(original.action()).toEqual('New')

  it "lets the new method use the old one", ->
    overload = new global8ball.Game.Overload
    original =
      action: () -> 'Foo'
    overload.overload original, 'action', (oldAction) -> () -> oldAction() + 'Bar'
    expect(original.action()).toEqual('FooBar')

  it "provides the same context for the old method", ->
    overload = new global8ball.Game.Overload
    original =
      action: () -> @value
      value: 500
    overload.overload original, 'action', (oldAction) -> () -> oldAction() * 2
    expect(original.action()).toEqual(1000)
