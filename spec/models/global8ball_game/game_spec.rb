require 'rails_helper'

module Global8ballGame
  RSpec.describe Game, type: :model do
    before do
      object_creator = ObjectCreator.new
      @config = object_creator.create_table_config
      @game = Game.create config: @config
    end

    it "provides timestamps on create and update" do
      expect(@game.created_at).to be_kind_of Time
      expect(@game.updated_at).to be_kind_of Time
    end

    # it "includes Global8ballGame::PhysicsConcern" do
    #   expect(Game.include? Global8ballGame::PhysicsConcern).to be_truthy
    # end

    it "provides config as attribute to store a hash" do
      expect(Game.all.first.config).to eq @config.deep_stringify_keys
    end

    it "validates presence of :config" do
      expect {Game.create}.to raise_error "Global8ballGame::Game is not valid. Errors: config is not present."
    end

    it "provides config as json, too" do
      expect(Game.all.first.config_json).to eq @config.to_json
    end
  end
end
