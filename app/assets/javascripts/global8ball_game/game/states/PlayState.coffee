#= require game/states/FullState

class global8ball.PlayState extends global8ball.FullState
  constructor: (g8bGame, @hasUi = true) ->
    super(g8bGame)
    @shotStrength = 1
    @shotStrengthChange = 0
    @currentlySettingForce = false
    @shot = new Phaser.Signal
    @aiming = false

  create: ->
    super()
    @yourCue = @createSprite 'cue1', 10, 10, visible: no
    @enemyCue = @createSprite 'cue2', 10, 10, visible: no
    if @hasUi
      @addCueControlGui()
      @table.inputEnabled = true
      @table.events.onInputDown.add @pointerDown
      @game.input.onUp.add @pointerUp
      @game.input.addMoveCallback @pointerMove
      @game.input.addMoveCallback @settingForce

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

  addCueControlGui: ->
    @cueControlGui = {}
    hCenter = @game.width / 2
    y = @game.height - 70
    elements =
      forceStrength:
        x: hCenter
        y: y
        w: 200
        h: 40
      lessenForce:
        x: hCenter - 120
        y: y
        w: 40
        h: 40
      strengthenForce:
        x: hCenter + 120
        y: y
        w: 40
        h: 40
      shootButton:
        x: hCenter + 160
        y: y
        w: 40
        h: 40
    for id of elements
      @cueControlGui[id] = @game.add.sprite elements[id].x, elements[id].y, id
      @cueControlGui[id].anchor.setTo 0.5, 0.5
      @cueControlGui[id].width = elements[id].w
      @cueControlGui[id].height = elements[id].h
      @cueControlGui[id].inputEnabled = true
      @cueControlGui[id].events.onInputOver.add @hoverOverControlGui
      @cueControlGui[id].events.onInputOut.add @leaveControlGui
    @cueControlGui.lessenForce.events.onInputDown.add @startLesseningForce
    @cueControlGui.strengthenForce.events.onInputDown.add @startStrengtheningForce
    @cueControlGui.forceStrength.events.onInputDown.add @startSettingForce
    @shotStrengthMask = @game.add.graphics 0, 0
    @cueControlGui.forceStrength.mask = @shotStrengthMask
    @shotStrengthMask.beginFill '#ffffff'
    @updateShotStrengthMask()

  startLesseningForce: (sprite, event) =>
    @shotStrengthChange = -@forceChangeSpeed

  startStrengtheningForce: (sprite, event) =>
    @shotStrengthChange = @forceChangeSpeed

  forceChangeSpeed: 0.001

  startSettingForce: (sprite, event) =>
    @stopChangingForce()
    @currentlySettingForce = true

  stopSettingForce: (sprite, event) =>
    @currentlySettingForce = false

  settingForce: (event, x, y) =>
    if @currentlySettingForce
      @shotStrength = Math.min 1, Math.max 0, (x + (@cueControlGui.forceStrength.width - @game.width) / 2) / @cueControlGui.forceStrength.width
      @updateShotStrengthMask()

  stopChangingForce: () =>
    @shotStrengthChange = 0

  hoverOverControlGui: (sprite, event) =>
    sprite.animations.frame = 1

  leaveControlGui: (sprite, event) =>
    sprite.animations.frame = 0

  update: ->
    super()
    if @shotStrengthChange isnt 0
      @shotStrength = Math.min 1, Math.max 0, @shotStrength + @shotStrengthChange
      @updateShotStrengthMask()

  updateShotStrengthMask: ->
    @shotStrengthMask.clear()
    x = (@game.width - @cueControlGui.forceStrength.width) / 2
    width = @cueControlGui.forceStrength.width * @shotStrength
    @shotStrengthMask.drawRect x, 0, width, @game.height

  pointerDown: (event, rawEvent) =>
    @aiming = true
    @aimAt rawEvent.clientX, rawEvent.clientY

  pointerUp: (event, rawEvent) =>
    if rawEvent.type is "mouseup" # onUp seems to catch other events as well, even from outside canvas!
      @aiming = false
      @stopSettingForce()
      @stopChangingForce()

  pointerMove: (event, x, y) =>
    if @aiming
      @aimAt x, y

  aimAt: (x, y) ->
    @yourCue.setAngleByAim x: x, y: y

  # @return {Boolean}
  canShoot: ->
    no

  cueCollidesWithWhiteBall: (cue, ball) ->
