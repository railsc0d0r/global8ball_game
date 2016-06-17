#= require game/prolog

class global8ball.FakeBackend
  request: (id, callback) ->
    mapping =
      table_parameters: 'getTableParameters'
      player_information: 'getPlayerInformation'
      game_state: 'getGameState'
    if typeof @[mapping[id]] is 'function'
      callback null, @[mapping[id]]()

  getTableParameters: ->
    {}

  getPlayerInformation: ->
    players:
      first:
        id: 'david'
        name: "David"
        shot: false
      second:
        id: 'goliath'
        name: "Goliath"
        shot: false
    viewer:
      id: 'david'
      name: 'David'

  getGameState: ->
    state: 'PlayForBegin'
