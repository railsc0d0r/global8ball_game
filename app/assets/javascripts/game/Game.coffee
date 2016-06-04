#= require game/game
#= require game/Controls.coffee
#= require game/states/Boot
#= require game/states/Preload
#= require game/states/PlayForBegin
#= require game/states/PlayForVictory
#= require game/states/ShowResult

class Game
  # @config is the game config
  # @data is the current state of the game, i.e. which ball is where, has anybody won, etc.
  constructor: (@config, @data)->
    @overload = new Game.Overload
    @renderer = if @config.server then Phaser.HEADLESS else Phaser.CANVAS
    @I18n = I18n
    @createPositionTranslation()

  createPositionTranslation: ->
    first =
      left: -100
      right: 100
      top: -50
      bottom: 50
    second =
      left: 120
      right: 1080
      top: 170
      bottom: 630
    @positionTranslation = new Game.PositionTranslation first, second

  translatePosition: (point) ->
    @positionTranslation.to point

  translatePositionBack: (point) ->
    @positionTranslation.from point

  t: (args...) ->
    @I18n.t.apply @I18n, args

  start: ->
    @phaserGame = new Phaser.Game( @config.size.width,
                                   @config.size.height,
                                   @renderer,
                                   @config.parent,
                                   null,
                                   false,
                                   true,
                                   @config.physicsConfig)

    @phaserGame.state.add 'Boot', new global8ball.Boot(@), true
    @phaserGame.state.add 'Preload', new global8ball.Preload @
    @phaserGame.state.add 'PlayForBegin', new global8ball.PlayForBegin @, new global8ball.EventSource
    @phaserGame.state.add 'PlayForVictory', new global8ball.PlayForVictory @
    @phaserGame.state.add 'ShowResult', new global8ball.ShowResult @

    controls = new global8ball.Controls @
    controls.attach @phaserGame.state.states.PlayForBegin
    controls.attach @phaserGame.state.states.PlayForVictory

  currentState: ->
    switch @data.state
      when 'PlayForBegin', 'PlayForVictory', 'ShowResult' then @data.state
      else throw new Error "Invalid game state."

  winner: ->
    "Someone"

  balls: ->
    @data.balls ? []

  enemy: ->
    @data.players.enemy

  you: ->
    @data.players.you

  # To avoid using the image URL mapping over and over again, replace image
  # methods on loader with methods doing the mapping before.
  overloadImageLoading: ->
    imageUrlMap = @config.imageUrlMap # For lexical binding
    @overload.overload @phaserGame.load, 'image', (oldLoadImage) -> (key, url, overwrite) -> oldLoadImage key, imageUrlMap[url], overwrite
    @overload.overload @phaserGame.load, 'images', (oldLoadImages) -> (key, urls) -> oldLoadImages keys, urls.map (url) -> imageUrlMap[url]
    @overload.overload @phaserGame.load, 'spritesheet', (oldLoadSpritesheet) -> (key, url, frameWidth, frameHeight) -> oldLoadSpritesheet key, imageUrlMap[url], frameWidth, frameHeight

  # For easier use of translations, overload Phaser text method.
  makeTextsTranslatable: ->
    I18n = @I18n
    @overload.overload @phaserGame.add, 'text', (oldAddText) ->
      (x, y, text, style, group) ->
        oldAddText x, y, (if typeof text is 'string' then I18n.t(text) else I18n.t(text.message, text.context)), style, group

  # Returns holes positions.
  holesData: () ->
    center = new Phaser.Point @phaserGame.width / 2, @phaserGame.height / 2
    xDiff = 480
    yDiff = 238
    yCenterDiff = 9
    # Minor corrections because table is slightly asymmetrical.
    leftTop:
      pos: center.clone().add -xDiff, -yDiff - 1
    centerTop:
      pos: center.clone().add 0, -yDiff - yCenterDiff - 1
    rightTop:
      pos: center.clone().add xDiff - 2, -yDiff - 2
    leftBottom:
      pos: center.clone().add -xDiff, yDiff - 1
    centerBottom:
      pos: center.clone().add 0, yDiff + yCenterDiff - 1
    rightBottom:
      pos: center.clone().add xDiff + 1, yDiff - 4

  # There a six borders, they are located between the holes.
  borderData: ->
    center = new Phaser.Point @phaserGame.width / 2, @phaserGame.height / 2
    horizontalSize = width: 460, height: 15
    verticalSize = width: 15, height: 460
    hXDiff = 240
    hYDiff = 245
    vXDiff = 485
    vYDiff = 0
    bottomLeft:
      size: horizontalSize
      pos: center.clone().add -hXDiff, hYDiff
    bottomRight:
      size: horizontalSize
      pos: center.clone().add hXDiff, hYDiff
    left:
      size: verticalSize
      pos: center.clone().add -vXDiff - 5, vYDiff
    right:
      size: verticalSize
      pos: center.clone().add vXDiff, vYDiff
    topLeft:
      size: horizontalSize
      pos: center.clone().add -hXDiff, -hYDiff - 7
    topRight:
      size: horizontalSize
      pos: center.clone().add hXDiff, -hYDiff - 7

# Helper class to overload methods.
class Game.Overload
  overload: (context, methodName, newMethodFactory) ->
    oldMethod = context[methodName].bind context
    context[methodName] = newMethodFactory oldMethod

# Translates coordinates from one coordinate system to another and back.
class Game.PositionTranslation
  constructor: (@first, @second) ->
    @firstWidth = @first.right - @first.left
    @firstHeight = @first.bottom - @first.top
    @secondWidth = @second.right - @second.left
    @secondHeight = @second.bottom - @second.top
    @toFactor =
      horizontal: @secondWidth / @firstWidth
      vertical: @secondHeight / @firstHeight
    @fromFactor =
      horizontal: 1 / @toFactor.horizontal
      vertical: 1 / @toFactor.vertical

  to: (point) ->
    x: @second.left + (point.x - @first.left) * @toFactor.horizontal
    y: @second.top + (point.y - @first.top) * @toFactor.vertical

  from: (point) ->
    x: @first.left + (point.x - @second.left)  * @fromFactor.horizontal
    y: @first.top + (point.y - @second.top) * @fromFactor.vertical

global8ball.Game = Game
