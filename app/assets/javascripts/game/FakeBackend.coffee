#= require game/prolog

class global8ball.FakeBackend
  request: (id, callback) ->
    mapping =
      game_state: 'getGameState'
    if typeof @[mapping[id]] is 'function'
      callback null, @[mapping[id]]()

  getGameState: ->
    state: 'PlayForBegin'
