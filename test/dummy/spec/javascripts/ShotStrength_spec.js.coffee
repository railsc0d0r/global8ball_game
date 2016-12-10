#= require game/ShotStrength

ShotStrength = global8ball.ShotStrength

describe 'ShotStrength', () ->

  it 'cannot be set to a value lower than zero', () ->
    strength = new ShotStrength
    strength.setTo -0.5
    expect(strength.get()).toEqual 0

  it 'cannot be set to value higher than one', () ->
    strength = new ShotStrength
    strength.setTo 1.5
    expect(strength.get()).toEqual 1

  it 'can strengthen on update', () ->
    strength = new ShotStrength
    strength.setTo 0.5
    strength.startStrengthening()
    strength.update()
    expect(strength.get()).toBeGreaterThan 0.5

  it 'can lessen on update', () ->
    strength = new ShotStrength
    strength.setTo 0.5
    strength.startLessening()
    strength.update()
    expect(strength.get()).toBeLessThan 0.5

  it 'provides stopping strengthening', () ->
    strength = new ShotStrength
    strength.setTo 0.5
    strength.startStrengthening()
    strength.stopChanging()
    strength.update()
    expect(strength.get()).toEqual 0.5

  it 'provides stopping lessening', () ->
    strength = new ShotStrength
    strength.setTo 0.5
    strength.startLessening()
    strength.stopChanging()
    strength.update()
    expect(strength.get()).toEqual 0.5

  it 'is not changing by default', () ->
    strength = new ShotStrength
    expect(strength.isChanging()).toBeFalsy()

  it 'is changing if it is strengthening', () ->
    strength = new ShotStrength
    strength.startStrengthening()
    expect(strength.isChanging()).toBeTruthy()

  it 'is changing if it is lessening', () ->
    strength = new ShotStrength
    strength.startLessening()
    expect(strength.isChanging()).toBeTruthy()
