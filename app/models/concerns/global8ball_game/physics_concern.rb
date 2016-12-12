#
# Global8ballGame::PhysicsConcern
#
# Lets model including this concern instanciate a table by given config and last_result
# and evaluate a shot on this table
#
# Models including this concern have to provide config and last_result as hashes representing the table_config and the last state
#
module Global8ballGame
  module PhysicsConcern
    extend ActiveSupport::Concern

    included do
      attr_reader :table
    end

    def eval_shot shot_hash
      shot = Shot.new shot_hash
      shoot shot
    end

    def eval_reinstating_at breakball_position
      reinstate_at breakball_position
    end


    def new_table_config
      config = {}

      config.merge!(Global8ballGame::Configuration::Table.new.config)
      config.merge!(Global8ballGame::Configuration::Border.new.config)
      config.merge!(Global8ballGame::Configuration::Hole.new.config)

      config
    end

    def initial_state player_1_id, player_2_id, stage_name="PlayForBegin", breaker=nil
      state = InitialState.new player_1_id, player_2_id, stage_name, breaker

      state.to_hash
    end

    private

    def initialize_table
      table = Global8ballGame::Table.new self.config
      table.initialize_state GameState.new self.last_result

      table
    end

    def shoot shot
      table = initialize_table
      table.shoot shot
      self.last_result = table.current_state

      self.last_result
    end

    def reinstate_at breakball_position
      table = initialize_table
      result = table.reinstate breakball_position

      self.last_result = table.current_state if result['reinstated']

      result
    end

    def handle_advices state
      advices = state.shot_results['events'].map {|event| event['advice'].to_sym}
      advices.delete :remove_ball

      advices.each do |advice|
        state = self.send advice, state
      end

      state
    end

    def change_breaker state
      state.current_players[0]['user_id'] = state.current_players[0]['user_id'] == self.player_1_id ? self.player_2_id : self.player_1_id
      state
    end
  end
end
