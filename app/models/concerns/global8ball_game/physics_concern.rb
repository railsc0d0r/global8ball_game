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
      state = State::Initial.new player_1_id, player_2_id, stage_name, breaker

      state.to_hash
    end

    def get_state
      old_state = State::Base.new self.last_result
      current_state = handle_advices old_state
      self.last_result = current_state.to_hash

      self.last_result
    end

    def last_result= state_hash
      Result.create result_set: state_hash, game: self
    end

    def results
      Result.find(game_id: self.id).to_a
    end

    private

    def initialize_table
      table = Global8ballGame::Table.new self.config
      table.initialize_state State::Base.new self.last_result

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
      advices = []
      state.shot_results['events'].each do |event|
        unless event['advice'] == 'reinstate_breakball'
          advices << event['advice'].to_sym
          state.shot_results['events'].delete(event)
        end
      end

      advices.each do |advice|
        # Some advices like :remove_ball won't be implemented.
        # So we send only advices already implemented to avoid triggering method_missing.
        state = self.send advice, state if self.class.private_method_defined? advice
      end

      state
    end

    def change_breaker state
      state.current_players[0]['user_id'] = state.current_players[0]['user_id'] == self.player_1_id ? self.player_2_id : self.player_1_id
      state
    end

    # Only happens in PlayForBegin
    def restart_round state
      raise "Restarting round happens only in PlayForBegin" unless state.stage_name == 'PlayForBegin'
      new_state = State::Initial.new self.player_1_id, self.player_2_id
      state.balls = new_state.balls
      state.round += 1

      state
    end
  end
end
