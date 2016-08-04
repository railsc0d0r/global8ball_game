class Game < ApplicationRecord
  include Global8ballGame::PhysicsConcern

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

    config = game.new_table_config
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
    self.last_result = initial_state self.player_1_id, self.player_2_id, stage_name, breaker
  end

  def eval_shot shot
    initialize_table config_hash
  end

  # Convinience methods to be used as standard in PhysicsConcern
  def last_result
    self.results.empty? ? nil : self.results.last.result_set
  end

  def last_result=result_set
    result = Result.new
    result.result_set = result_set

    self.results << result
    self.save!
  end
end
