#= require game/phaser
#= require game/prolog

# All relevant state events.
events = ["init", "preload", "create", "update", "shutdown"]

# Transforms a state so it is possible to listen to state events, i.e. when
# init(), preload(), create(), update() and shutdown() are called.
#
# After calling mixinStateEvents(state), listeners can be added via
# state.addStateEventListener().
global8ball.mixinStateEvents = (state) ->
  stateEventSignals = {}
  events.forEach (event) -> stateEventSignals[event] = new Phaser.Signal

  state.addStateEventListener = (event, listener, context) ->
    stateEventSignals[event].add listener, context

  events.forEach (event) ->
    if state[event]
      oldMethod = state[event]
      state[event] = () ->
        oldMethod.call state
        stateEventSignals[event].dispatch state, event
    else
      state[event] = () ->
        stateEventSignals[event].dispatch state, event

  return state
