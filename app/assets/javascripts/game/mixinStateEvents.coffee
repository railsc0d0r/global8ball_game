#= require game/prolog

# All relevant state events.
events = ["init", "preload", "create", "update", "shutdown"]

# Transforms a state so it is possible to listen to state events, i.e. when
# init(), preload(), create(), update() and shutdown() are called.
#
# After calling mixinStateEvents(state), listeners can be added via
# state.addStateEventListener().
#
# @param {Phaser.State} state
# @return State to which event handling was added to.
global8ball.mixinStateEvents = (state) ->
  stateEventSignals = {}
  events.forEach (event) -> stateEventSignals[event] = new Phaser.Signal

  # Adds an event listener for an event to the state. Works as {Phaser.Signal.add},
  # with the exception of the event type prepended to the argument list.
  #
  # @param {string} event Type of the event.
  # @param {function} listener
  # @param {any} context
  # @param {number} priority
  # @param {array} args Additional arguments.
  # @return {Phaser.SignalBinding} Binding which can be used to detach the
  #   listener from observing state events.
  state.addStateEventListener = (event, listener, context, priority, args...) ->
    stateEventSignals[event].add listener, context, priority, args...

  events.forEach (event) ->
    if state[event]
      oldMethod = state[event]
      state[event] = (args...) ->
        oldMethod.call state, args...
        stateEventSignals[event].dispatch state, event
    else
      state[event] = () ->
        stateEventSignals[event].dispatch state, event

  return state
