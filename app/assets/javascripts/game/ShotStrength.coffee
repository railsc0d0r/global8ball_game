#= require game/prolog

# Represents the shot strength.
class global8ball.ShotStrength
  # @param {number} changeSpeed Speed with which value is changed when lessening/
  #   strengthening value
  constructor: (@changeSpeed = 0.001) ->
    @currentChange = 0
    @value = 0.5

  # Returns the current value.
  #
  # @return {number}
  get: () ->
    @value

  # Sets the current value and restricts it to [0, 1].
  #
  # @param {number} newValue
  setTo: (newValue) ->
    @value = Math.min 1, Math.max 0, newValue

  # Start strengthening the shot strength on every update.
  startStrengthening: () ->
    @currentChange = @changeSpeed

  # Start lessening the shot strength on every update.
  startLessening: () ->
    @currentChange = -@changeSpeed

  # Stop changing the shot strength on every update. Applies to both
  # strengthening and lessening.
  stopChanging: () ->
    @currentChange = 0

  # Wether the value is currently changing on every update.
  #
  # @return {boolean}
  isChanging: () ->
    @currentChange isnt 0

  # Update the shot strength.
  update: () ->
    @setTo @get() + @currentChange
