require 'rails_helper'

module Global8ballGame
  RSpec.describe Table, type: :model do
    before do
      @players = create_players
      @config = create_table_config
      @config.deep_stringify_keys!
    end

    it "can be initialized w/ a given config" do
      expect{Global8ballGame::Table.new @config}.to_not raise_error
    end

    private

    def create_table_config
      config = {}

      config.merge!(Global8ballGame::TableConfig.new.config)
      config.merge!(Global8ballGame::BorderConfig.new.config)
      config.merge!(Global8ballGame::HoleConfig.new.config)
      config.merge!(players_config)

      config
    end

    def players_config
      {
        player_1: {
          user_id: @players[:player_1].id,
          name: @players[:player_1].name
        },
        player_2: {
          user_id: @players[:player_2].id,
          name: @players[:player_2].name
        }
      }
    end

    def create_players
      {
        player_1: FactoryGirl.create(:player),
        player_2: FactoryGirl.create(:player)
      }
    end
  end
end
