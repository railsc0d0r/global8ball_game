require 'rails_helper'

module Global8ballGame
  RSpec.describe Result, type: :model do
    before do
      @result_set = {
        a: 1,
        b: "123"
      }

      object_creator = ObjectCreator.new
      @player_1 = object_creator.players[:player_1]
      @player_2 = object_creator.players[:player_2]
      @game = Game.create player_1_id: @player_1.id, player_1_name: @player_1.name, player_2_id: @player_2.id, player_2_name: @player_2.name
    end

    it "provides an attribute to store a result_set-hash" do
      Result.create result_set: @result_set, game: @game
      expect(Result.all.first.result_set).to eq @result_set.deep_stringify_keys
    end

    it "belongs to a Game" do
      Result.create result_set: @result_set, game: @game
      expect(Result.all.first.game).to eq @game
    end

    it "validates presence of :result_set" do
      expect {Result.create game: @game}.to raise_error "Global8ballGame::Result is not valid. Errors: result_set is not present."
    end

    it "validates presence of a game" do
      expect {Result.create result_set: @result_set}.to raise_error "Global8ballGame::Result is not valid. Errors: game_id is not present."
    end

    it "provides timestamps on create and update" do
      result = Result.create result_set: @result_set, game: @game

      expect(result.created_at).to be_kind_of Time
      expect(result.updated_at).to be_kind_of Time
    end
  end
end
