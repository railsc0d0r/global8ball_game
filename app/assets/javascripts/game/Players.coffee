#= require game/prolog
#= require game/Account
#= require game/Player
#= require game/Viewer

class global8ball.Players
  # @param {global8ball.Viewer} viewer
  # @param {global8ball.Player} first
  # @param {global8ball.Player} second
  constructor: (@viewer, @first, @second) ->

  # @return {global8ball.Viewer}
  getViewer: () ->
    @viewer

  # @return {global8ball.Player}
  getFirst: () ->
    @first

  # @return {global8ball.Player}
  getSecond: () ->
    @second

  # @return {boolean}
  viewerPlays: () ->
    # Only first player needs to be checked, because if the second player would
    # be the viewer, she becomes the first player.
    @viewer.account.equals @first.account

# @param {object} playerData
# @param {object} viewerData
# @return {global8ball.Players}
global8ball.Players.create = (playerData, viewerData) ->
  firstPlayer = createPlayerFromData playerData.first, viewerData
  secondPlayer = createPlayerFromData playerData.second, viewerData
  viewer = new global8ball.Viewer new global8ball.Account viewerData.id, viewerData.name
  if viewer.account.equals secondPlayer.account
    new global8ball.Players viewer, secondPlayer, firstPlayer
  else
    new global8ball.Players viewer, firstPlayer, secondPlayer

# @param {object} playerData
# @param {object} viewerData
# @return {globla8ball.Player}
createPlayerFromData = (playerData, viewerData) ->
  account = new global8ball.Account playerData.id, playerData.name
  isViewer = playerData.id is viewerData.id
  new global8ball.Player account, isViewer
