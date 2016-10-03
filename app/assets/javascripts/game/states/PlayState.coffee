#= require game/sprites/Cue
#= require game/prolog
#= require game/states/FullState

# Base class for all states where players can play, i.e. there are cues, balls
# are shot, etc.
class global8ball.PlayState extends global8ball.FullState
  constructor: (gameConfig, players, @events) ->
    super gameConfig, players
    @ballsConfig = []

  init: (gameState) ->
    super()
    @initGameState gameState

  initGameState: (gameState) ->
    @ballsConfig = new global8ball.config.Balls gameState.balls
    @currentPlayers = new global8ball.config.CurrentPlayers gameState.current_players

  create: ->
    super()
    @cues =
      player1: @createSprite 'cue1', 10, 10, visible: no
      player2: @createSprite 'cue2', 10, 10, visible: no
    @world.bringToTop @spriteGroups.cues
    @cues.player1.setOwner @players.getFirst()
    @cues.player2.setOwner @players.getSecond()
    @cues.player1.initStates()
    @cues.player2.initStates()

  # Sets the initial state of the cue, according to the owner being one of the
  # current players or not.
  #
  # @param {global8ball.Cue} cue
  setInitialCueState: (cue) ->
    if @currentPlayers.contains cue.getOwner()
      cue.putOnTable()
    else
      cue.retreatFromTable()

  getPhysicsGroupSpecs: () ->
    specs = super()
    specs.cue1 =
      spriteKey: 'cue'
      spriteGroupId: 'cues'
      collisionGroupId: 'cue1'
    specs.cue2 =
      spriteKey: 'cue'
      spriteGroupId: 'cues'
      collisionGroupId: 'cue2'
    return specs

  spriteClasses: () ->
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
    cueBody.sprite.retreatFromTable()

  shoot: (shot) ->
    cue = @getCueByPlayer shot.userId
    if cue
      cue.shoot shot

  # Returns the cue which belongs to player with ID playerId or null if none
  # such cue exists.
  getCueByPlayer: (playerId) ->
    cues = [@cues.player1, @cues.player2].filter (cue) -> cue.getOwner().getId() is playerId
    if cues.length > 0
      cues[0]
    else
      null

  # @param {number} power A value sent from shot control, ranges from 0 to 1.
  # @param {Phaser.Signal} onSendShot Event sink for shot events.
  sendShotEvent: (power, onSendShot) ->
    power = power * 2
    cue = @currentlyControlledCue()
    if cue
      ev =
        shot:
          user_id: @players.getFirst().getId()
          angle: cue.getAngle()
          strength: power
      onSendShot.dispatch ev

  # @return {global8ball.Cue|null}
  currentlyControlledCue: () ->
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
      body.damping = @gameConfig.config.tableDamping
      body.mass = ballConfig.mass
      body.ccdSpeedThreshold = 1
      body.ccdIterations = 1000

    config = data: ballConfig
    if spriteKey
      config.spriteKey = spriteKey
    ball = @createSprite physicsGroupId, x, y, config, makeBallBody

    ball
