#= require game/physics/P2Init
#= require game/prolog
#= require game/sprites/Cue
#= require game/sprites/CueAdder
#= require game/states/FullState

# Base class for all states where players can play, i.e. there are cues, balls
# are shot, etc.
class global8ball.PlayState extends global8ball.FullState
  constructor: (gameConfig, players, @events) ->
    super gameConfig, players
    @ballsConfig = []
    @ballsInHolesCount = 0

  init: (gameState) ->
    super()
    @initGameState gameState

  initGameState: (gameState) ->
    @ballsConfig = new global8ball.config.Balls gameState.balls
    @currentPlayers = new global8ball.config.CurrentPlayers gameState.current_players

  create: ->
    super()
    (new global8ball.physics.P2Init @gameConfig).applyContactMaterials @physics
    (new global8ball.CueAdder).addCues @

  # Sets the initial state of the cue, according to the owner being one of the
  # current players or not.
  #
  # @param {global8ball.Cue} cue
  setInitialCueState: (cue) ->
    if @currentPlayers.contains cue.getOwner()
      cue.putOnTable()
    else
      cue.retreatFromTable()

  # @return {Object.<string, function>} Map of classes
  spriteClasses: ->
    classes = super()
    classes.cues = global8ball.Cue
    return classes

  update: ->
    super()
    if @events.hasShot()
      @shoot @events.getShot()
      @events.clearShot()

  aimAt: (x, y) ->
    @cues.player1.aimAt x: x, y: y

  # @return {Boolean}
  canShoot: ->
    no

  # A cue collides with a (white) ball. Immediately make the cue go away.
  cueCollidesWithWhiteBall: (cueBody, ballBody) =>
    ballBody.velocity.x = cueBody.velocity.x
    ballBody.velocity.y = cueBody.velocity.y
    cueBody.sprite.retreatFromTable()

  # @param {global8ball.Shot}
  shoot: (shot) ->
    cue = @getCueByPlayer shot.userId
    if cue
      cue.shoot shot

  # Returns the cue which belongs to player with ID playerId or null if none
  # such cue exists.
  getCueByPlayer: (playerId) ->
    @getSprite new global8ball.spritePredicates.CueByPlayer @players.byId playerId

  # @param {number} power A value sent from shot control, ranges from 0 to 1.
  # @param {Phaser.Signal} onSendShot Event sink for shot events.
  sendShotEvent: (power, onSendShot) ->
    power = power * @gameConfig.getTable().getMaximumBreakballSpeed()
    cue = @currentlyControlledCue()
    angle = cue.getAngle()
    rotation = angle*Math.PI/180
    if cue
      ev =
        shot:
          user_id: @players.getFirst().getId()
          angle: angle
          strength: power
          velocity:
            x: -power * Math.cos rotation
            y: -power * Math.sin rotation
      onSendShot.dispatch ev

  # @return {global8ball.Cue|null}
  currentlyControlledCue: ->
    @cues.player1

  createBallSprite: (physicsGroupId, ballConfig, spriteKey = null) ->
    x = @game.width  / 2 + @physics.p2.mpx ballConfig.position.x
    y = @game.height / 2 + @physics.p2.mpx ballConfig.position.y
    radius = @physics.p2.mpx ballConfig.radius

    makeBallBody = (body) =>
      body.clearShapes()
      radius = radius
      offsetX = 0
      offsetY = 0
      rotation = 0
      body.addCircle radius, offsetX, offsetY, rotation
      body.damping = @gameConfig.getTable().getDamping()
      body.mass = ballConfig.mass
      body.data.ccdSpeedThreshold = 1
      body.data.ccdIterations = 100
      body.setMaterial @gameConfig.getBallMaterial()

    config = data: ballConfig
    if spriteKey
      config.spriteKey = spriteKey
    ball = @createSprite physicsGroupId, x, y, config, makeBallBody

    ball

  ballFallsIntoHole: (ballBody, holeBody) =>
    ballBody.sprite.removeFromTable @ballsInHolesCount++
