#=require game/prolog

class global8ball.GroupSpecs

  specs =
    common:
      borders:
        spriteKey: 'border'
        spriteGroupId: 'borders'
        collisionGroupId: 'borders'
      holes:
        spriteKey: 'hole'
        spriteGroupId: 'holes'
        collisionGroupId: 'holes'
    play:
      cue1:
        spriteKey: 'cue'
        spriteGroupId: 'cues'
        collisionGroupId: 'cue1'
      cue2:
        spriteKey: 'cue'
        spriteGroupId: 'cues'
        collisionGroupId: 'cue2'
    oneWhiteBall:
      white:
        spriteKey: 'whiteBall'
        spriteGroupId: 'white'
        collisionGroupId: 'white'
        collides: [
          {
            groupId: 'cue1'
          }
          {
            groupId: 'cue2'
          }
          {
            groupId: 'borders'
          }
          {
            groupId: 'holes'
            callback: 'whiteBallFallsIntoHole'
          }
          {
            groupId: 'playBalls'
          }
          {
            groupId: 'black'
          }
        ]
      cue1:
        collides: [
          {
            groupId: 'white'
            callback: 'cueCollidesWithWhiteBall'
          }
        ]
      cue2:
        collides: [
          {
            groupId: 'white'
            callback: 'cueCollidesWithWhiteBall'
          }
        ]
      borders:
        collides: [
          {
            groupId: 'white'
          }
        ]
    twoWhiteBalls:
      white1:
        spriteKey: 'whiteBall'
        spriteGroupId: 'white'
        collisionGroupId: 'white1'
        collides: [
          {
            groupId: 'cue1'
          }
          {
            groupId: 'white2'
          }
          {
            groupId: 'borders'
            callback: 'whiteBallCollidesWithBorder'
          }
          {
            groupId: 'holes'
            callback: 'whiteBallFallsIntoHole'
          }
        ]
      white2:
        spriteKey: 'whiteBall'
        spriteGroupId: 'white'
        collisionGroupId: 'white2'
        collides: [
          {
            groupId: 'cue2'
          }
          {
            groupId: 'white1'
          }
          {
            groupId: 'borders'
            callback: 'whiteBallCollidesWithBorder'
          }
          {
            groupId: 'holes'
            callback: 'whiteBallFallsIntoHole'
          }
        ]
      cue1:
        collides: [
          {
            groupId: 'white1'
            callback: 'cueCollidesWithWhiteBall'
          }
        ]
      cue2:
        collides: [
          {
            groupId: 'white2'
            callback: 'cueCollidesWithWhiteBall'
          }
        ]
      borders:
        collides: [
          {
            groupId: 'white1'
          }
          {
            groupId: 'white2'
          }
        ]
      holes:
        collides: [
          {
            groupId: 'white1'
          }
          {
            groupId: 'white2'
          }
        ]
    blackBall:
      black:
        spriteKey: 'blackBall'
        spriteGroupId: 'black'
        collisionGroupId: 'black'
        collides: [
          {
            groupId: 'white'
          }
          {
            groupId: 'playBalls'
          }
          {
            groupId: 'borders'
          }
        ]
      borders:
        collides: [
          {
            groupId: 'black'
          }
        ]
    playBalls:
      playBalls:
        spriteGroupId: 'playBalls'
        collisionGroupId: 'playBalls'
        collides: [
          {
            groupId: 'white'
          }
          {
            groupId: 'black'
          }
          {
            groupId: 'playBalls'
          }
          {
            groupId: 'borders'
          }
        ]
      borders:
        collides: [
          {
            groupId: 'playBalls'
          }
        ]

  get: (keys...) ->
    resultSpecs = {}
    for key in keys
      resultSpecs = @merge resultSpecs, specs[key]
    return resultSpecs

  merge: (objects...) ->
    result = {}
    for object in objects
      for key, value of object
        if result[key]
          if typeof value is 'object' and not Array.isArray value
            result[key] = @merge value, result[key]
          else if Array.isArray(result[key]) and Array.isArray value
            result[key] = result[key].concat value
          else
            error = new Error 'Invalid merging.'
            error.currentResult = result
            error.currentKey = key
            error.currentValue = value
            throw error
        else
          result[key] = value
    return result
