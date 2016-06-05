#= require game/states/PlayState

class global8ball.PlayForBegin extends global8ball.PlayState
  constructor: (g8bGame, @eventSource) ->
    super g8bGame

  create: ->
    super()
    @youShot = no
    @enemyShot = no
    @createWhiteBalls()
    @yourCue.setTargetBall @yourBall
    @enemyCue.setTargetBall @enemyBall
    @world.bringToTop @spriteGroups.cues
    @yourCue.show()

  getPhysicsGroupSpecs: () ->
    specs = super()
    specs.white1 =
      spriteKey: 'whiteBall'
      spriteGroupId: 'white'
      collisionGroupId: 'white1'
      collides: [
        {
          groupId: 'cue1'
        }
        {
          groupId: 'borders'
          callback: 'whiteBallCollidesWithBorder'
        }
      ]
    specs.white2 =
      spriteKey: 'whiteBall'
      spriteGroupId: 'white'
      collisionGroupId: 'white2'
      collides: [
        {
          groupId: 'cue2'
        }
        {
          groupId: 'borders'
          callback: 'whiteBallCollidesWithBorder'
        }
      ]
    specs.cue1.collides = [
      {
        groupId: 'white1'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]
    specs.cue2.collides = [
      {
        groupId: 'white2'
        callback: 'cueCollidesWithWhiteBall'
      }
    ]

    specs.borders.collides = [
      {
        groupId: 'white1'
      }
      {
        groupId: 'white2'
      }
    ]
    specs

  spriteClasses: () ->
    classes = super()
    classes.white1 = global8ball.Ball
    classes.white2 = global8ball.Ball
    return classes

  createWhiteBalls: () ->
    @g8bGame.
      balls().
      filter((ballData) -> ballData.id is 'you' or ballData.id is 'enemy').
      forEach (ballData) =>
        physicsGroupId = if ballData.id is 'you' then 'white1' else 'white2'
        ballProperty = if ballData.id is 'you' then 'yourBall' else 'enemyBall'
        pos = @g8bGame.translatePosition ballData.pos
        @[ballProperty] = @createSprite physicsGroupId, pos.x, pos.y, data: ballData, id: ballData.id

  whiteBallCollidesWithBorder: (ballBody, borderBody) =>

  update: ->
    super()
    if @eventSource.youShot() and not @youShot
      @youShot = true
    if @eventSource.enemyShot() and not @enemyShot
      @enemyShot = true

  # @inheritdoc
  canShoot: ->
    not @youShot
