#= require game/prolog
#= require game/ShotStrength

# Adds cue controls to a Phaser state. This is done by creating a StateControls
# instance every time a play state is entered (exactly: when Phaser.State.create()
# is called).
class global8ball.Controls
  # @param {function} onShoot Function called when the shoot button is pressed.
  constructor: (@onShoot = () ->)->

  # Attaches itself to the events of a state.
  #
  # @param {Phaser.State} state
  attach: (state) ->
    state.addStateEventListener 'create', @createEventHappened, @

  # Listener attached to create events of a state.
  #
  # @param {Phaser.State} state State causing the event.
  # @param {string} eventType
  createEventHappened: (state, eventType) ->
    @addControls state

  # Add controls to a state.
  #
  # @param {Phaser.State} state
  addControls: (state) ->
    (StateControls.addTo state).onShoot = @onShoot

# When entering a play state, an instance of this class is created and used
# to add controls and connect events.
#
# @member {object} aimingNextFrame When the player clicks, this will be set to
#   the coordinates of the click. Is consumed immediately on the next update() call.
# @member {boolean} aiming Wether the player is currently aiming with the cue.
# @member {global8ball.ShotStrength} shotStrength Current shot strength.
# @member {boolean} currentlySettingForce Wether the play is currently setting
#   the shot strength via the strengthmeter.
# @member {Phaser.Graphics} shotStrengthMask Mask used together with the strengthmether
#   to actually show the current shot strength.
# @member {object} cueControlGui Holds control GUI sprites.
# @member {boolean} inputDownHandledBySprite Wether a pointer down event was
#   handled by a sprite, so geneeric down handlers should not be processed.
class StateControls

  # Creates new state controls and adds them to the state.
  #
  # @param {Phaser.State} state
  @addTo: (state) ->
    (new StateControls state).attach()

  # @param {Phaser.State} state
  constructor: (@state) ->
    @aimingNextFrame = null
    @aiming = false
    @shotStrength = new global8ball.ShotStrength
    @currentlySettingForce = false
    @inputDownHandledBySprite = false

  # Attaches itself to the state if not already done.
  attach: () ->
    if @attached # If already attached to the state, do not attach again.
      return @
    @attach = () =>

    @stateUpdateEventBinding = @state.addStateEventListener 'update', @update, @
    @stateShutdownEventBinding = @state.addStateEventListener 'shutdown', @shutdown, @
    @addCueControlGui @state
    @state.input.onDown.add @pointerDown, @
    @state.input.onUp.add @pointerUp, @
    @state.input.addMoveCallback @pointerMove
    return @

  # Called when the state shutdowns. Sprites do not need to be cleaned up (they
  # are automatically deleted by Phaser), but event bindings have to be
  # disconnected.
  # Cleanup is only needed for custom event handling (e.g. a self-defined
  # Phaser.Signal). Listeners added to the various Phaser.Input signals are
  # automatically removed when switching to another state.
  shutdown: () ->
    @stateUpdateEventBinding.detach()
    @stateShutdownEventBinding.detach()

  # Called on every update of the state. Handles changes regarding shot strength.
  update: () ->
    @updateShotStrength()
    @consumeAimingFromLastFrame()

  # Checks for changes regarding the shot strength and updates it accordingly.
  updateShotStrength: () ->
    @shotStrength.update()
    @updateShotStrengthMask()

  # When there was a click in the last frame, check if the cue should be aimed.
  # Why not do it directly? Generic input listeners are called before sprite-specific
  # ones, ignoring priority. Because the state event handlers (like create) can
  # only be called at the beginning (in a sane way), it's impossible to attach
  # listeners to sprites created by the state.
  consumeAimingFromLastFrame: () ->
    if @aimingNextFrame
      # Check if cue control GUI already handled the event.
      if not @inputDownHandledBySprite
        @state.aimAt @aimingNextFrame.x, @aimingNextFrame.y
        # If pointer is still down, start to aim the cue. Check is necessary,
        # because the player could click so fast that the pointer is down for
        # only one frame.
        if @aimPointer.isDown
          @aiming = true
      @aimingNextFrame = null
      @inputDownHandledBySprite = false

  # Adds the whole GUI to control the cue, i.e. set the strength. Also includes
  # a shoot button.
  addCueControlGui: () ->
    @cueControlGui = {}
    hCenter = @state.game.width / 2
    y = @state.game.height - 70
    elements =
      forceStrength:
        x: hCenter
        y: y
        w: 200
        h: 40
        action: "startSettingForce"
      lessenForce:
        x: hCenter - 120
        y: y
        w: 40
        h: 40
        action: "startLesseningForce"
      strengthenForce:
        x: hCenter + 120
        y: y
        w: 40
        h: 40
        action: "startStrengtheningForce"
      shootButton:
        x: hCenter + 160
        y: y
        w: 40
        h: 40
        action: "pressShootButton"
    for id of elements
      @cueControlGui[id] = @state.game.add.sprite elements[id].x, elements[id].y, id
      @cueControlGui[id].anchor.setTo 0.5, 0.5
      @cueControlGui[id].width = elements[id].w
      @cueControlGui[id].height = elements[id].h
      @cueControlGui[id].inputEnabled = true
      @cueControlGui[id].events.onInputOver.add @hoverOverControlGui
      @cueControlGui[id].events.onInputOut.add @leaveControlGui
      @cueControlGui[id].events.onInputDown.add @[elements[id].action], @
      @cueControlGui[id].events.onInputDown.add @spriteHandlesInputDown, @
    @shotStrengthMask = @state.game.add.graphics 0, 0
    @cueControlGui.forceStrength.mask = @shotStrengthMask
    @shotStrengthMask.beginFill '#ffffff'
    @updateShotStrengthMask()

  # Generic listener for mousedown events.
  #
  # @param {Phaser.Pointer} pointer
  # @param {MouseEvent} rawEvent
  pointerDown: (pointer, rawEvent) =>
    @aimingNextFrame = x: pointer.x, y: pointer.y
    @aimPointer = pointer

  # Generic listener for mouseup events.
  #
  # @param {Phaser.Pointer} pointer (Unused)
  # @param {MouseEvent} rawEvent
  pointerUp: (pointer, rawEvent) =>
    if rawEvent.type is "mouseup" # onUp seems to catch other events as well, even from outside canvas!
      @aiming = false
      @stopSettingForce()
      @stopChangingForce()

  # Generic listener for mousemove events.
  #
  # @param {Phaser.Pointer} pointer
  # @param {number} x
  # @param {number} y
  pointerMove: (pointer, x, y) =>
    @settingForce pointer, x, y
    if @aiming
      @state.aimAt x, y

  # Called when player starts lowering the shot strength via the corresponding button.
  #
  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  startLesseningForce: (sprite, pointer) =>
    @shotStrength.startLessening()

  # Called when player starts increasing the shot strength via the corresponding button.
  #
  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  startStrengtheningForce: (sprite, pointer) =>
    @shotStrength.startStrengthening()

  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  startSettingForce: (sprite, pointer) =>
    @shotStrength.stopChanging()
    @currentlySettingForce = true
    @settingForce pointer, pointer.x, pointer.y

  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  stopSettingForce: (sprite, pointer) =>
    @currentlySettingForce = false

  # @param {Phaser.Pointer} pointer
  # @param {number} x
  # @param {number} y
  settingForce: (pointer, x, y) ->
    if @currentlySettingForce
      @shotStrength.setTo (x + (@cueControlGui.forceStrength.width - @state.game.width) / 2) / @cueControlGui.forceStrength.width
      @updateShotStrengthMask()

  # Stop shot strength changing (increase/decrease buttons)
  stopChangingForce: () =>
    @shotStrength.stopChanging()

  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  hoverOverControlGui: (sprite, pointer) =>
    sprite.animations.frame = 1

  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  leaveControlGui: (sprite, pointer) =>
    sprite.animations.frame = 0

  # @param {Phaser.Sprite} sprite
  # @param {Phaser.Pointer} pointer
  pressShootButton: (sprite, pointer) =>
    @onShoot @shotStrength.get()

  # Overwrite with a real event handler.
  onShoot: ->

  # Updates the shot strength mask used to show the current strength.
  updateShotStrengthMask: ->
    @shotStrengthMask.clear()
    x = (@state.game.width - @cueControlGui.forceStrength.width) / 2
    width = @cueControlGui.forceStrength.width * @shotStrength.get()
    @shotStrengthMask.drawRect x, 0, width, @state.game.height

  # Listener called when a sprite is clicked.
  spriteHandlesInputDown: ->
    @inputDownHandledBySprite = true
