App.events = App.cable.subscriptions.create "EventsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (state) ->
    # Called when there's incoming data on the websocket for this channel
    dummy_component.game.events.onSetState.dispatch(JSON.parse state)
    return
