App.reinstate_breakball = App.cable.subscriptions.create {"ReinstateBreakballChannel", game_id: dummy_component.game_id},
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
