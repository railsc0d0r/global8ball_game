#= require game/prolog
#= require game/phaser

# Represents a cue. A cue is always bound to a player (therefore there are always
# exactly two cues, one for each player).
#
# A cue can be in one of three states:
# - Ready to shoot and visible. Used for cues the current viewer controls.
# - Currently shooting.
# - Away from table. If the cue's player is currently not allowed to shoot, this
#   is the state it is in.
#
# Cue states are represented by classes. They are pre-generated on initialization
# and switched by setting them by key.
class global8ball.Cue extends Phaser.Sprite
  # Default distance to ball.
  DEFAULT_DISTANCE_TO_BALL = 20

  targetBall: null
  distanceToBall: DEFAULT_DISTANCE_TO_BALL
  shootingPower: 0

  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @states = {}
    @keyOfCurrentState = STATES.INITIAL # A lie!
    @visibleWhenReady = no

  # This cue belongs to the viewer.
  belongsToViewer: ->
    @visibleWhenReady = yes

  # Initializes the various cue states.
  initStates: ->
    @states[STATES.INITIAL] = new InitialState @
    @states[STATES.READY] =
      if @visibleWhenReady
        new ReadyToShootOnTableState @
      else
        new ReadyToShootAwayFromTableState @
    @states[STATES.SHOOTING] = new ShootingState @
    @states[STATES.AWAY] = new AwayFromTableState @

  # Sets the next state by its key.
  #
  # @param {string} stateKey
  nextState: (stateKey) ->
    @states[stateKey].init()
    @keyOfCurrentState = stateKey

  # Returns the current state.
  #
  # @return {CueState}
  getCurrentState: ->
    @states[@keyOfCurrentState]

  # Set who the cue belongs to.
  #
  # @param {global8ball.Player} owner
  setOwner: (@owner) ->

  # Returns the owner.
  #
  # @return {global8ball.Player}
  getOwner: ->
    @owner

  # @param {global8ball.Ball} targetBall
  setTargetBall: (@targetBall) ->
    @updatePosition()

  # @param {number} newAngle New angle in degrees (0-360)
  setAngle: (newAngle) ->
    @body.angle = newAngle
    @updatePosition()

  # @return {number}
  getAngle: () ->
    @body.angle

  # @param {Point} Position to aim at. The cue will point TO that position, not FROM it!
  setAngleByAim: (pos) ->
    if @targetBall
      @setAngle Math.atan2(@targetBall.body.y - pos.y, @targetBall.body.x - pos.x) / MATH_FACTOR

  aimAt: (pos) ->
    @getCurrentState().aimAt pos

  updatePosition: ()->
    if @targetBall
      @body.x = @targetBall.x + @getOffsetToBall() * Math.cos(MATH_FACTOR * @body.angle)
      @body.y = @targetBall.y + @getOffsetToBall() * Math.sin(MATH_FACTOR * @body.angle)

  # Set distance between cue and ball. Can also be set to null, which means the default value is used.
  #
  # @param {number} distance
  setDistanceToBall: (distanceToBall) ->
    @distanceToBall = distanceToBall ? DEFAULT_DISTANCE_TO_BALL

  # @return {number}
  getOffsetToBall: () ->
    @width / 2 + @distanceToBall

  # Let the cue shoot.
  shoot: (shot) ->
    @getCurrentState().shoot shot

  # @return {number}
  getShotDirectionInRadians: ->
    (@body.rotation + 1.5 * Math.PI) % (2 * Math.PI)

  # Move the cue away from the table, hides it, etc..
  retreatFromTable: ->
    @getCurrentState().retreatFromTable()

  # Put the cue on the table.
  putOnTable: ->
    @getCurrentState().putOnTable()

  # Moves the cue far away from the table.
  moveFarAwayFromTable: ->
    @body.x = -10000
    @body.y = -10000
    @body.velocity.mx = 0
    @body.velocity.my = 0

# Abstract base class for cue states.
#
# Contains several methods meant to be overriden by the concrete states.
#
# @property {global8ball.Cue} Cue the state belongs to.
class CueState

  # @param {global8ball.Cue} cue
  constructor: (@cue) ->

  # Sets the cue state to the state designated by the state key.
  #
  # @param {string} stateKey
  nextState: (stateKey) ->
    @cue.nextState stateKey

  # Initializes the cue state.
  #
  # @override
  init: ->

  # Let the cue aim at a position.
  #
  # @param pos {object} Must contain numeric x and y properties.
  # @override
  aimAt: (pos) ->

  # Take the cue away from the table.
  #
  # @override
  retreatFromTable: ->

  # Attempt to shoot.
  #
  # @param {global8ball.Shot} shot
  # @override
  shoot: (shot) ->

  # Attempt to put cue back on the table.
  #
  # @override
  putOnTable: ->

# Initial, unfinished state. Needed because not all properties of a sprite
# are initialized after {Phaser.Sprite.constructor} has run.
class InitialState extends CueState
  putOnTable: ->
    @nextState STATES.READY

  retreatFromTable: ->
    @nextState STATES.AWAY

# Cue is ready to shoot and on the table.
class ReadyToShootOnTableState extends CueState
  init: ->
    @cue.updatePosition()
    @cue.visible = yes
    @cue.updatePosition()

  shoot: (shot) ->
    @cue.setAngle shot.angle
    @cue.shootingPower = shot.strength
    @nextState STATES.SHOOTING

  aimAt: (pos) ->
    @cue.setAngleByAim pos
    @cue.updatePosition()

# Cue is ready to shoot, but away from the table.
class ReadyToShootAwayFromTableState extends CueState
  init: ->
    @cue.visible = no
    @cue.moveFarAwayFromTable()

  shoot: (shot) ->
    @cue.visible = yes
    @cue.setAngle shot.angle
    @cue.shootingPower = shot.strength
    @nextState STATES.SHOOTING

# Cue is currently shooting, but has not hit the ball yet.
class ShootingState extends CueState
  init: ->
    body = @cue.body
    body.velocity.mx = - @cue.shootingPower * Math.cos(MATH_FACTOR * body.angle)
    body.velocity.my = - @cue.shootingPower * Math.sin(MATH_FACTOR * body.angle)

  retreatFromTable: ->
    @nextState STATES.AWAY

# Cue is away from the table.
class AwayFromTableState extends CueState
  init: ->
    @cue.visible = no
    @cue.moveFarAwayFromTable()

  # Puts the cue back onto the table.
  putOnTable: ->
    @nextState STATES.READY

STATES =
  INITIAL: 'initial'
  READY: 'ready'
  SHOOTING: 'shooting'
  AWAY: 'away'

MATH_FACTOR = Math.PI/180
