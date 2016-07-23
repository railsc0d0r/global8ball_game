class Game < ApplicationRecord
  has_many :results

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

    config.merge!(Global8ballGame::Table.config)
    config.merge!(Global8ballGame::Border.config)
    config.merge!(Global8ballGame::Hole.config)
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
end
