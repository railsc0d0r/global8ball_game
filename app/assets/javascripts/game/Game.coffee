#= require game/config/Game
#= require game/GameEvents
#= require game/prolog
#= require game/states/Boot
#= require game/states/Preload
#= require game/states/PlayForBegin
#= require game/states/PlayForVictory
#= require game/states/Reinstate
#= require game/states/ShowResult
#= require game/states/WaitForGameState

# Wrapper around the whole game, also provides the public API.
class Game
  # @config is the game config
  # @data is the current state of the game, i.e. which ball is where, has anybody won, etc.
  constructor: (@config, @data)->
    @overload = new Game.Overload
    @renderer = if @config.server then Phaser.HEADLESS else Phaser.CANVAS
    @I18n = I18n
    @createPositionTranslation()
    @events = new global8ball.GameEvents

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

  # @return {Game} The game itself.
  start: ->
    gameConfig = new global8ball.config.Game @config

    @phaserGame = new Phaser.Game(
      @config.size.width,
      @config.size.height,
      @renderer,
      @config.parent,
      null,
      false,
      true,
      gameConfig.getPhysicsConfig()
    )

    @players = global8ball.Players.create gameConfig.getPlayerData(), gameConfig.getCurrentViewerData()

    @phaserGame.state.add 'Boot', new global8ball.Boot(@), true
    @phaserGame.state.add 'Preload', new global8ball.Preload @currentState()
    @phaserGame.state.add 'WaitForConfiguration', new global8ball.WaitForGameState @events
    @phaserGame.state.add 'PlayForBegin', new global8ball.PlayForBegin gameConfig, @players, @events
    @phaserGame.state.add 'PlayForVictory', new global8ball.PlayForVictory gameConfig, @players, @events
    @phaserGame.state.add 'Reinstate', new global8ball.Reinstate gameConfig, @players, @events
    @phaserGame.state.add 'ShowResult', new global8ball.ShowResult gameConfig, @players

    if @players.viewerPlays()
      controls = new global8ball.Controls (power) =>
        @phaserGame.state.states[@phaserGame.state.current].sendShotEvent power, @events.onSendShot
      controls.attach @phaserGame.state.states.PlayForBegin
      controls.attach @phaserGame.state.states.PlayForVictory

    return @

  currentState: ->
    switch @data.state
      when 'PlayForBegin', 'PlayForVictory', 'ShowResult' then @data.state
      else throw new Error "Invalid game state."

  balls: ->
    (@data.balls ? []).map (ball) =>
      id: ball.id
      color: ball.color
      pos: @translatePosition ball.pos

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
