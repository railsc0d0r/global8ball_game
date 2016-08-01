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
    result = Result.new
    result.result_set = initial_state self.player_1_id, self.player_2_id, stage_name, breaker

    self.results << result
    self.save!
  end

  def eval_shot shot
    initialize_table config_hash
  end
end
