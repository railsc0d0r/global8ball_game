#= require game/mixinStateEvents

describe 'State events Mixin', () ->

  # Shortcut
  mixinStateEvents = global8ball.mixinStateEvents

  # All relevant state events.
  events = ["init", "preload", "create", "update", "shutdown"]

  describe 'An observer', () ->

    events.forEach (event) ->

      it 'is called with the state and a ' + event + ' event', () ->

        class State

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

      it 'is called within a specific context for ' + event + ' event', () ->

        class State
        state = mixinStateEvents(new State)

        observedContext = null
        listener = (state, event) ->
          observedContext = @

        context = {}
        state.addStateEventListener event, listener, context

        state[event]()

        expect(observedContext).to.equal context

      it 'is called with respect to its priority for ' + event + ' events', () ->

        class State

        calls = []
        firstListener = () -> calls.push 'first'
        secondListener = () -> calls.push 'second'
        thirdListener = () -> calls.push 'third'

        state = mixinStateEvents new State
        state.addStateEventListener event, secondListener, undefined, 50
        state.addStateEventListener event, thirdListener, undefined, 0
        state.addStateEventListener event, firstListener, undefined, 100
        state[event]()

        expect(calls).to.deep.equal ['first', 'second', 'third']

  describe 'State', () ->

    events.forEach (event) ->

      it 'calls the original ' + event + '() method with the right context', () ->

        class State
        events.forEach (event) -> State::[event] = () -> @[event + '_called'] = @

        state = mixinStateEvents(new State)

        state[event]()

        expect(state[event + '_called']).to.equal state

      it 'gains a ' + event + '() method if it had none', () ->

        class State
        events.filter((ev) -> ev isnt event).forEach (event) -> State::[event] = () ->

        state = mixinStateEvents new State

        state[event]()
