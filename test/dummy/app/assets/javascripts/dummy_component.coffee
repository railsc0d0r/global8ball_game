class this.DummyComponent
        constructor: (@game_id) ->

        loadGame: () ->
                  canvas_placeholder = document.createElement('div')
                  canvas_placeholder.setAttribute('id', 'da-game')
                  document.body.appendChild(canvas_placeholder)

                  current_viewer_select = document.getElementById 'current_viewer'
                  current_viewer = JSON.parse(current_viewer_select.options[current_viewer_select.selectedIndex].value)
                  @config.current_viewer = current_viewer

                  current_breaker_select = document.getElementById 'current_breaker'

                  unless current_breaker_select == null
                    @current_breaker = parseInt(current_breaker_select.options[current_breaker_select.selectedIndex].value)

                  current_stage_select = document.getElementById 'current_stage'

                  unless current_stage_select == null
                    @current_stage = current_stage_select.options[current_stage_select.selectedIndex].value

                  document.getElementById('menu_top').style.display = 'none'
                  document.getElementById('menu_right').style.display = 'inline'

                  @game = initGlobal8Ball(@config)
                  @game.events.onGetState.add(@requestCurrentState, @)
                  @game.events.onSendShot.add(@sendShot, @)
                  @game.events.onSendReinstateBreakball.add(@sendReinstateBreakball, @)

                  return

        parseSelectedStage: () ->
                  current_stage_select = document.getElementById 'current_stage'
                  current_stage = current_stage_select.options[current_stage_select.selectedIndex].value

                  breaker_element = document.getElementById 'breaker'

                  if current_stage == 'PlayForVictory' || current_stage == 'ShowResult'
                    breaker_element.style.display = ''
                  else
                    breaker_element.style.display = 'none'

                  return

        requestCurrentState: () ->
                  App.state.perform 'getState', {current_stage: @current_stage, current_breaker: @current_breaker}

                  return

        sendShot: (shot) ->
                  App.shot.perform 'setShot', shot

                  return

        sendReinstateBreakball: (position) ->
                  App.reinstate_breakball.perform 'reinstate_breakball', position

                  return
