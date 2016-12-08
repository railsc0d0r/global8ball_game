require 'rails_helper'

module Global8ballGame
  RSpec.describe InitialState, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players
    end

    it "returns an initial state for PlayForBegin" do
      state = InitialState.new @players[:player_1].id, @players[:player_2].id
      expected_state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id

      expect(state.to_hash).to eql expected_state.deep_stringify_keys
    end

    it "returns an initial state for PlayForVictory" do
      breaker = @players[:player_1].id
      state = InitialState.new @players[:player_1].id, @players[:player_2].id, 'PlayForVictory', breaker
      expected_state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForVictory", breaker

      expect(state.to_hash).to eql expected_state.deep_stringify_keys
    end
  end
end
