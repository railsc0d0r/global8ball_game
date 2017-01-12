require 'rails_helper'

module Global8ballGame
  RSpec.describe Game, type: :model do
    before do
      object_creator = ObjectCreator.new
      @config = object_creator.create_table_config
    end

    it "provides timestamps on create and update" do
      game = Game.create

      expect(game.created_at).to be_kind_of Time
      expect(game.updated_at).to be_kind_of Time
    end

    # it "includes Global8ballGame::PhysicsConcern" do
    #   expect(Game.include? Global8ballGame::PhysicsConcern).to be_truthy
    # end

    it "provides config as attribute to store a hash" do
      Game.create config: @config

      expect(Game.all.first.config).to eq @config.deep_stringify_keys
    end
  end
end
