module Global8ballGame
  class GameState
    attr_reader :stage_name
    attr_accessor :round, :balls, :current_players, :current_results

    def initialize state
      @stage_name = state['current_stage']['stage_name']
      @round = state['current_stage']['round']
      @balls = state['balls']
      @current_players = state['current_players']
      @current_results = state['current_results']
    end

    def to_hash
      hash = {
        current_stage: {
          stage_name: @stage_name,
          round: @round
        },
        balls: @balls,
        current_players: @current_players,
        current_results: @current_results
      }
      hash.deep_stringify_keys
    end
  end
end
