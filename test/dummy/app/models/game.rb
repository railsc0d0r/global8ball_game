class Game < ApplicationRecord
  has_many :results, dependent: :destroy

  after_initialize do |game|
    game.player_1 = Player.all[0].nil? ? nil : Player.all[0]
    game.player_2 = Player.all[1].nil? ? nil : Player.all[1]

    players_config = {
      player_1: {
        user_id: game.player_1.user_id,
        name: game.player_1.name
      },
      player_2: {
        user_id: game.player_2.user_id,
        name: game.player_2.name
      }
    }

    config = {}

    config.merge!(Global8ballGame::Table.new.config)
    config.merge!(Global8ballGame::Border.new.config)
    config.merge!(Global8ballGame::Hole.new.config)
    config.merge!(players_config)

    game.config = config.to_json
  end

  def config_hash
    JSON.parse(config)
  end

  def player_1= player
    self.player_1_id = player.nil? ? nil : player.id
  end

  def player_1
    Player.find(player_1_id)
  end

  def player_2= player
    self.player_2_id = player.nil? ? nil : player.id
  end

  def player_2
    Player.find(player_2_id)
  end

  def initialize_state stage_name, breaker
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

    result = Result.new
    result.result_set=state

    self.results << result
    self.save!
  end
end
