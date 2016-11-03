module Global8ballGame
  class GameState
    attr_reader :stage_name
    attr_accessor :round, :balls, :current_players, :current_results

    def initialize state
      @stage_name = state['current_stage']['stage_name']
      @round = state['current_stage']['round']
      @current_players = state['current_players']
      @current_results = state['current_results']
    end
  end
end
