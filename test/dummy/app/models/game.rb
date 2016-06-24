class Game < ApplicationRecord
  after_initialize do |game|
    config = {}

    config.merge!(Global8ballGame::Table.config)
    config.merge!(Global8ballGame::Border.config)
    config.merge!(Global8ballGame::Hole.config)

    game.config = config.to_json
  end

  def config_hash
    JSON.parse(config)
  end
end
