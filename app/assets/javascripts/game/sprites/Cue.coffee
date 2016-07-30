#= require game/prolog
#= require game/phaser

# Represents a cue. A cue is always bound to a player (therefore there are always
# exactly two cues, one for each player).
#
# A cue can be in one of three states:
# - Ready to shoot. It's the player's turn to shoot (or both players may shoot).
# - Currently shooting.
# - Away from table. If the cue's player is currently not allowed to shoot, this
#   is the state it is in.
#
# Cue states are represented by classes.
class global8ball.Cue extends Phaser.Sprite
  # Default distance to ball.
  DEFAULT_DISTANCE_TO_BALL = 20

  targetBall: null
  distanceToBall: null

  constructor: (game, x, y, key, frame) ->
    super game, x, y, key, frame
    @setCueState new InitialState

  # Initializes the state of the cue and stores it.
  setCueState: (state) ->
    state.setCue @
    state.init()
    @cueState = state

  # Set who the cue belongs to.
  #
  # @param {global8ball.Player} player
  setOwner: (@player) ->

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
    @cueState.aimAt pos

  updatePosition: ()->
    if @targetBall
      @body.x = @targetBall.x + @getOffsetToBall() * Math.cos(MATH_FACTOR * @body.angle)
      @body.y = @targetBall.y + @getOffsetToBall() * Math.sin(MATH_FACTOR * @body.angle)

  # Set distance between cue and ball. Can also be set to null, which means the default value is used.
  #
  # @param {number} distance
  setDistanceToBall: (@distanceToBall) ->

  # @return {number}
  getOffsetToBall: () ->
    @width / 2 + if typeof @distanceToBall is 'number' then @distanceToBall else DEFAULT_DISTANCE_TO_BALL

  # Let the cue shoot.
  shoot: (power) ->
    @cueState.shoot power

  # @return {number}
  getShotDirectionInRadians: ->
    (@body.rotation + 1.5 * Math.PI) % (2 * Math.PI)

  # Move the cue away from the table, hides it, etc..
  retreatFromTable: ->
    @cueState.retreatFromTable()

  # Put the cue on the table.
  putOnTable: ->
    @cueState.putOnTable()

# Abstract base class for cue states.
#
# Contains several methods meant to be overriden by the concrete states.
#
# @property {global8ball.Cue} Cue the state belongs to.
class CueState

  # Set the next state of the cue.
  #
  # @param {CueState} newState
  setCueState: (newState) ->
    @cue.setCueState newState
    @cue = null

  # Set the cue this state belongs to.
  #
  # @param {global8ball.Cue} cue
  setCue: (@cue) ->

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
  # @param {number} power
  # @override
  shoot: (power) ->

  # Attempt to put cue back on the table.
  #
  # @override
  putOnTable: ->

# Initial, unfinished state. Needed because not all properties of a sprite
# are initialized after {Phaser.Sprite.constructor} has run.
class InitialState extends CueState
  putOnTable: ->
    @setCueState new ReadyToShootState

  retreatFromTable: ->
    @setCueState new AwayFromTableState

# Cue is ready to shoot.
class ReadyToShootState extends CueState
  init: ->
    @cue.updatePosition()
    @cue.visible = yes
    @cue.updatePosition()

  shoot: (power) ->
    @setCueState new ShootingState power

  aimAt: (pos) ->
    @cue.setAngleByAim pos
    @cue.updatePosition()

# Cue is currently shooting, but has not hit the ball yet.
class ShootingState extends CueState
  constructor: (@power) ->

  init: ->
    body = @cue.body
    body.velocity.mx = - @power * Math.cos(MATH_FACTOR * body.angle)
    body.velocity.my = - @power * Math.sin(MATH_FACTOR * body.angle)

  retreatFromTable: ->
    @setCueState new AwayFromTableState

# Cue is away from the table.
class AwayFromTableState extends CueState
  init: ->
    @cue.visible = no
    body = @cue.body
    body.x = -10000
    body.y = -10000
    body.velocity.mx = 0
    body.velocity.my = 0

  # Puts the cue back onto the table.
  putOnTable: ->
    @setCueState new ReadyToShootState

MATH_FACTOR = Math.PI/180
