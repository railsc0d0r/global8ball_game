#= require game/mixinStateEvents

describe 'State events Mixin', () ->

  # Shortcut
  mixinStateEvents = global8ball.mixinStateEvents

  # All relevant state events.
  events = ["init", "preload", "create", "update", "shutdown"]

  describe 'An observer', () ->

    events.forEach (event) ->

      it 'is called with the state and a ' + event + ' event', () ->

        observedState = null
        observedEvent = null
        listener = (state, event) ->
          observedState = state
          observedEvent = event

        state = mixinStateEvents(new class State)
        state.addStateEventListener event, listener

        state[event]()

        expect(observedState).to.equal state
        expect(observedEvent).to.equal event

      it 'is called within a specific context for ' + event + ' event', () ->

        observedContext = null
        listener = (state, event) ->
          observedContext = @

        state = mixinStateEvents(new class State)
        context = {}
        state.addStateEventListener event, listener, context

        state[event]()

        expect(observedContext).to.equal context

      it 'is called with respect to its priority for ' + event + ' events', () ->

        calls = []
        firstListener = () -> calls.push 'first'
        secondListener = () -> calls.push 'second'
        thirdListener = () -> calls.push 'third'

        state = mixinStateEvents(new class State)
        state.addStateEventListener event, secondListener, undefined, 50
        state.addStateEventListener event, thirdListener, undefined, 0
        state.addStateEventListener event, firstListener, undefined, 100
        state[event]()

        expect(calls).to.deep.equal ['first', 'second', 'third']

      it 'is called with additional arguments for ' + event + ' events', () ->

        additionalArguments = ['foo', 'bar']
        observedArguments = []
        listener = (state, event, rest...) -> observedArguments = rest

        state = mixinStateEvents(new class State)
        state.addStateEventListener event, listener, undefined, undefined, additionalArguments...

        state[event]()

        expect(observedArguments).to.deep.equal additionalArguments


      it 'can be removed for ' + event + ' events', () ->

        listenerCalled = no
        listener = () -> listenerCalled = yes

        state = mixinStateEvents(new class State)
        binding = state.addStateEventListener event, listener
        binding.detach()

        state[event]()

        expect(listenerCalled).to.equal no

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
