#= require game/prolog

class global8ball.Preload extends Phaser.State
  constructor: (@g8bGame) ->

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
    background:      'background'
    blackBall:       'black_ball'
    border:          'border'
    crosshair:       'crosshair'
    cue:             'cue'
    hole:            'hole'
    redBall:         'red_ball'
    table:           'table_pool_without_background'
    whiteBall:       'white_ball'
    yellowBall:      'yellow_ball'

  @SPRITESHEETS:
    forceStrength:
      url: 'force_strength'
      width: 3660
      height: 444
    lessenForce:
      url: 'lessen_force'
      width: 576
      height: 440
    shootButton:
      url: 'shoot_button'
      width: 280
      height: 279
    strengthenForce:
      url: 'strengthen_force'
      width: 576
      height: 440

  create: ->
    @game.state.start @g8bGame.currentState()
