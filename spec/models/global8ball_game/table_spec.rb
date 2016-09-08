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
  end
end
