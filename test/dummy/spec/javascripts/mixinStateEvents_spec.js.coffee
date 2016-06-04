#= require game/mixinStateEvents

describe 'State events Mixin', () ->

  # Shortcut
  mixinStateEvents = global8ball.mixinStateEvents

  # All relevant state events.
  events = ["init", "preload", "create", "update", "shutdown"]

  events.forEach (event) ->

    it 'calls observers with the state and a ' + event + ' event', () ->

      class State
      events.forEach (event) -> State::[event] = () ->

      state = mixinStateEvents(new State)

      observedState = null
      observedEvent = null
      listener = (state, event) ->
        observedState = state
        observedEvent = event

      state.addStateEventListener event, listener

      state[event]()

      expect(observedState).to.equal state
      expect(observedEvent).to.equal event

    it 'calls the original ' + event + '() method with the right context', () ->

      class State
      events.forEach (event) -> State::[event] = () -> @[event + '_called'] = @

      state = mixinStateEvents(new State)

      state[event]()

      expect(state[event + '_called']).to.equal state
