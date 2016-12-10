module Global8ballGame
  class InitialState < GameState
    def initialize player_1_id, player_2_id, stage_name="PlayForBegin", breaker=nil
      @stage_name = stage_name
      @round = 1
      @shot_results = {
        shot: {},
        foul: false,
        events: []
      }
      @current_players = []
      @current_results = []
      @balls = Global8ballGame::Configuration::BallPosition.config(stage_name)

      if stage_name == 'PlayForBegin'
        @balls[0][:owner] = player_1_id
        @balls[1][:owner] = player_2_id
        @current_players << { user_id: player_1_id}
        @current_players << { user_id: player_2_id}
      end

      if stage_name == 'PlayForVictory'
        @balls[0][:owner] = breaker
        @current_players << { user_id: breaker}
        @current_results << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }
      end

      if stage_name == 'ShowResult'
        @current_results << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }

        1.upto 3 do |round|
          @current_results << {
            stage_name: 'PlayForVictory',
            round: round,
            winner: breaker
          }
        end
      end

      @balls.map! {|ball| ball.deep_stringify_keys}
      @current_results.map! {|result| result.deep_stringify_keys}
      @current_players.map! {|player| player.deep_stringify_keys}
      @shot_results.deep_stringify_keys!
    end
  end
end
