#= require game/states/PlayState

class global8ball.PlayForBegin extends global8ball.PlayState
  constructor: (g8bGame, @eventSource) ->
    super g8bGame
    @shot.add @shoot

  create: ->
    super()
    @youShot = @g8bGame.data.players.you.shot
    @enemyShot = @g8bGame.data.players.enemy.shot
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

  # Attempt to shoot. If shooting is allowed, teleport the shooting player's
  # cue to an appropriate position and accelerate it accordingly.
  # Shooting positions are abstract board positions and must be translated back.
  #
  # @param {Point} start
  # @param {Point} end
  # @param {string} player
  shoot: (start, end, player) =>
    rs = @g8bGame.translatePositionBack start
    re = @g8bGame.translatePositionBack end
    dx = re.x - rs.x
    dy = re.y - rs.y
    abs = Math.sqrt dx*dx + dy*dy
    f = if abs > MAX_FORCE then MAX_FORCE / abs else 1
    dx *= FORCE_FACTOR / f
    dy *= FORCE_FACTOR / f
    @balls.filter((ball) -> ball.id is 'you').forEach (ball) ->
      ball.body.velocity.x = dx
      ball.body.velocity.y = dy

  # @inheritdoc
  canShoot: ->
    not @youShot
