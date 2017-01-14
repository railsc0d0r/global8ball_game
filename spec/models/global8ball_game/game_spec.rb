require 'rails_helper'

module Global8ballGame
  RSpec.describe Game, type: :model do
    before do
      object_creator = ObjectCreator.new
      @config = object_creator.create_table_config
      @player_1 = object_creator.players[:player_1]
      @game = Game.create config: @config
    end

    it "provides timestamps on create and update" do
      expect(@game.created_at).to be_kind_of Time
      expect(@game.updated_at).to be_kind_of Time
    end

    it "includes Global8ballGame::PhysicsConcern" do
      expect(Game.include? Global8ballGame::PhysicsConcern).to be_truthy
    end

    it "provides config as attribute to store a hash" do
      expect(Game.all.first.config).to eq @config.deep_stringify_keys
    end

    it "validates presence of :config" do
      expect {Game.create}.to raise_error "Global8ballGame::Game is not valid. Errors: config is not present."
    end

    it "provides config as json, too" do
      expect(Game.all.first.config_json).to eq @config.to_json
    end

    it "has a collection of results" do
      result = Result.create result_set: {a: "test"}, game: @game

      expect(@game.results).to be_kind_of Ohm::Set
      expect(@game.results.first).to eq result
    end

    it "deletes all results belonging to it if deleted" do
      game_id = @game.id
      result = Result.create result_set: {a: "test"}, game: @game
      @game.delete

      expect(Result.find(game_id: game_id)).to be_empty
    end

    it "stores player 1 as id" do
      Game.create config: @config, player_1_id: @player_1.id
      expect(Game.all.to_a.last.player_1_id).to eq @player_1.id
    end
  end
end
