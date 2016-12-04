require 'rails_helper'

module Global8ballGame
  RSpec.describe PhysicsConcern, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @config = @object_creator.create_table_config
      @config[:table][:damping] = 0.2 # Sets damping to a fixed value to correctly predict results without accounting for random variations
      @config.deep_stringify_keys!

      @game = Game.create!

      @game.config_json = @config.to_json
      @game.save
    end

    it "can provide a new table_config with definitions for the table, borders and holes." do
      config = @game.new_table_config
      expect(config.keys).to match_array [:table, :borders, :holes]
      expect(config[:table].keys).to match_array [:damping, :max_breakball_speed, :scaling_factor, :contact_materials]
      expect(config[:borders].keys).to match_array [:left, :leftBottom, :rightBottom, :right, :rightTop, :leftTop]
      expect(config[:holes].keys).to match_array [:leftTop, :leftBottom, :centerBottom, :rightBottom, :rightTop, :centerTop]
    end

    it "can provide an initial state for PlayForBegin to be saved as last_result." do
      state = @game.initial_state @game.player_1_id, @game.player_2_id
      expected_state = @object_creator.initial_state @game.player_1_id, @game.player_2_id

      expect(state).to eql expected_state
    end

    it "can provide an initial state for PlayForVictory to be saved as last_result." do
      breaker = @game.player_1_id
      state = @game.initial_state @game.player_1_id, @game.player_2_id, "PlayForVictory", breaker
      expected_state = @object_creator.initial_state @game.player_1_id, @game.player_2_id, "PlayForVictory", breaker

      expect(state).to eql expected_state
    end
  end
end
