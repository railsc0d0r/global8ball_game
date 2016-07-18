class this.DummyComponent
        constructor: (@config, @ball_positions) ->

        loadGame: () ->
                  current_viewer_select = document.getElementById('current_viewer')
                  current_viewer = JSON.parse(current_viewer_select.options[current_viewer_select.selectedIndex].value)
                  @config.current_viewer = current_viewer

                  current_stage_select = document.getElementById('current_stage')
                  window.current_stage = current_stage_select.options[current_stage_select.selectedIndex].value

                  document.getElementById('menu_top').style.display = 'none'
                  document.getElementById('menu_right').style.display = 'inline'

                  window.game = window.initGlobal8Ball(@config)
                  window.game.events.onGetState.add(@requestCurrentState, @)

                  return

        parseCurrentStage: () ->
                  current_stage_select = document.getElementById('current_stage')
                  current_stage = current_stage_select.options[current_stage_select.selectedIndex].value

                  if (current_stage == 'PlayForVictory')
                    document.getElementById('breaker').style.display = ''
                  else
                    document.getElementById('breaker').style.display = 'none'

                  return

        requestCurrentState: () ->
                  @ball_positions['PlayForBegin'].balls[0].owner = @config.player_1.user_id
                  @ball_positions['PlayForBegin'].balls[1].owner = @config.player_2.user_id

                  current_breaker_select = document.getElementById('current_breaker')
                  current_breaker = parseInt(current_breaker_select.options[current_breaker_select.selectedIndex].value)
                  @ball_positions['PlayForVictory'].balls[0].owner = current_breaker

                  options =
                    current_stage:
                      stage_name: window.current_stage
                      round: 0
                    balls: @ball_positions[window.current_stage].balls

                  if window.current_stage == 'PlayForVictory'
                    options.current_players = [
                      { user_id: current_breaker }
                    ]

                  if window.current_stage == 'PlayForBegin'
                    options.current_players = [
                      { user_id: @config.player_1.user_id },
                      { user_id: @config.player_2.user_id }
                    ]

                  window.game.events.onSetState.dispatch(options)

                  return
