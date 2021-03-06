#= require game/prolog

# Preload state. Used for loading graphics, sounds, etc. while showing a
# preload bar.
class global8ball.Preload extends Phaser.State
  constructor: (@startState) ->

  preload: ->
    preloader = @game.add.sprite @game.width / 2, @game.height / 2, 'preloader-bar'
    preloader.anchor.setTo 0.5, 0.5
    loader = @game.load
    for key of Preload.IMAGES
      url = 'game/' + Preload.IMAGES[key] + '.png'
      loader.image key, url
    for key of Preload.SPRITESHEETS
      spritesheet = Preload.SPRITESHEETS[key]
      url = 'game/' + spritesheet.url + '.png'
      loader.spritesheet key, url, spritesheet.width, spritesheet.height

  @IMAGES:
    background:            'background'
    blackBall:             'black_ball'
    border:                'border'
    cue:                   'cue'
    hole:                  'hole'
    redBall:               'red_ball'
    forceStrength:         'ui_elements/slider-track_active'
    ballShadow:            'shadow_ball'
    sliderTrackBackground: 'ui_elements/slider-track-bg'
    sliderTrackInactive:   'ui_elements/slider-track_inactive'
    table:                 'table_pool_without_background'
    whiteBall:             'white_ball'
    yellowBall:            'yellow_ball'

  @SPRITESHEETS:
    crosshair:
      url: 'ui_elements/pointer-crosshair_combined'
      width: 15
      height: 15
    forceButton:
      url: 'ui_elements/slider-track-button_combined'
      width: 33
      height: 34
    lessenForce:
      url: 'ui_elements/slider-track-minus_combined'
      width: 52
      height: 54
    shootButton:
      url: 'ui_elements/pointer-ball_combined'
      width: 48
      height: 49
    strengthenForce:
      url: 'ui_elements/slider-track-plus_combined'
      width: 52
      height: 54

  create: ->
    @game.state.start 'WaitForConfiguration'
