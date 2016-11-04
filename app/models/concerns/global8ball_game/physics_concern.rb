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

    def eval_shot shot
      shoot shot
    end

    protected

    def new_table_config
      config = {}

      config.merge!(Global8ballGame::Configuration::Table.new.config)
      config.merge!(Global8ballGame::Configuration::Border.new.config)
      config.merge!(Global8ballGame::Configuration::Hole.new.config)

      config
    end

    def initial_state player_1, player_2, stage_name="PlayForBegin", breaker=nil
      state = {
          current_stage: {
              stage_name: stage_name,
              round: 1
            }
        }

      state.merge!(Global8ballGame::Configuration::BallPosition.config stage_name)

      current_players = {
        current_players: []
      }

      current_results = {
        current_results: []
      }

      if stage_name == 'PlayForBegin'
        state[:balls][0][:owner] = player_1
        state[:balls][1][:owner] = player_2
        current_players[:current_players] << { user_id: player_1}
        current_players[:current_players] << { user_id: player_2}
      end

      if stage_name == 'PlayForVictory'
        state[:balls][0][:owner] = breaker
        current_players[:current_players] << { user_id: breaker}
        current_results[:current_results] << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }
      end

      state.merge!(current_players)

      if stage_name == 'ShowResult'
        current_results[:current_results] << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }

        1.upto 3 do |round|
          current_results[:current_results] << {
            stage_name: 'PlayForVictory',
            round: round,
            winner: breaker
          }
        end
      end

      state.merge!(current_results)

      state
    end

    private

    def initialize_table
      table = Global8ballGame::Table.new self.config
      table.initialize_last_state self.last_result

      table
    end

    def shoot shot
      table = initialize_table
      table.shoot shot
      self.last_result = table.current_state

      self.last_result
    end
  end
end
