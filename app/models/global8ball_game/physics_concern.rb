#
# Global8ballGame::PhysicsConcern
#
# Lets model including this concern instanciate a physics-world by given config and last state
# and interact w/ this world to return a new state end evaluate certain rules by given ruleset
#
module Global8ballGame
  module PhysicsConcern
    extend ActiveSupport::Concern

    included do

    end

    protected

    def new_table_config
      config = {}

      config.merge!(Global8ballGame::Table.new.config)
      config.merge!(Global8ballGame::Border.new.config)
      config.merge!(Global8ballGame::Hole.new.config)

      config
    end

    def initial_state stage_name, breaker, player_1, player_2
      state = {
          current_stage: {
              stage_name: stage_name,
              round: 1
            }
        }

      state.merge!(Global8ballGame::BallPosition.config stage_name)

      current_players = {
        current_players: []
      }

      current_results = {
        current_results: []
      }

      if stage_name == 'PlayForBegin'
        state[:balls][0][:owner] = self.player_1.id
        state[:balls][1][:owner] = self.player_2.id
        current_players[:current_players] << { user_id: self.player_1.id}
        current_players[:current_players] << { user_id: self.player_2.id}
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
  end
end
