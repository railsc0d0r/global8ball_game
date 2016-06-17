#= require game/prolog

###

Contains helper functions to create events.

Events must be serializable objects, so it would be unwise to use a class to
create them. But their structure should be documented, so they will not be
created directly where needed, but instead only via these functions, to avoid
them being defined implicitly only.

###

# Creates a shoot event.
#
# @param {global8ball.Player} player The player which is shooting.
# @param {number} angle Angle of the shot (0 to 360 degrees).
# @param {number} strength Shot strength, given as value ranging from 0 (no force
#   at all) to 1 (full power).
global8ball.createShootEvent = (player, angle, strength) ->
  player: player.getId()
  angle: angle
  strength: strength
