require 'rails_helper'

module Global8ballGame
  RSpec.describe Table, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players
      @config = @object_creator.create_table_config
      @config.deep_stringify_keys!
      @table = Global8ballGame::Table.new @config
    end

    it "can be initialized w/ a given config" do
      expect{Global8ballGame::Table.new @config}.to_not raise_error
    end

    it "provides a world-object w/ 6 borders and 6 holes after initializing" do
      expect(@table.world.bodies.count {|e| e.body_type == "border"}).to eq 6
      expect(@table.world.bodies.count {|e| e.body_type == "hole"}).to eq 6
      expect(@table.world.bodies.count).to eq 12
    end

    it "has 2 balls defined after initializing the opening state for PlayForBegin" do
      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      expect(@table.world.bodies.count {|e| e.body_type == "ball"}).to eq 2
    end

    it "has 16 balls defined after initializing the opening state for PlayForVictory" do
      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForVictory"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      expect(@table.world.bodies.to_a.count {|e| e.body_type == "ball"}).to eq 16
    end

    it "has no balls defined after initializing the opening state for ShowResult" do
      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "ShowResult"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      expect(@table.world.bodies.to_a.count {|e| e.body_type == "ball"}).to eq 0
    end

    it "evaluates a shot given by frontend" do
      shot = {
        user_id: @players[:player_1].id,
        velocity: {
          x: @config['table']['max_breakball_speed'],
          y: 0
        }
      }
      shot.deep_stringify_keys!

      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      @table.shoot shot

    end
  end
end
