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
      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      expect(@table.world.bodies.count {|e| e.body_type == "ball"}).to eq 2
    end

    it "has 16 balls defined after initializing the opening state for PlayForVictory" do
      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForVictory"
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

    it "evaluates a shot given by frontend in PlayForBegin" do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: @config['table']['max_breakball_speed'],
          y: 0
        }
      }
      shot_hash.deep_stringify_keys!
      shot = Shot.new shot_hash

      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      @table.shoot shot

    end

    it "evaluates a shot given by frontend in PlayForVictory" do
      breaker = @players[:player_1].id

      shot_hash = {
        user_id: breaker,
        velocity: {
          x: @config['table']['max_breakball_speed'],
          y: 0
        }
      }
      shot_hash.deep_stringify_keys!
      shot = Shot.new shot_hash

      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForVictory", breaker
      state.deep_stringify_keys!
      @table.initialize_last_state state
      @table.shoot shot
    end

    it "shoots breakball into a hole in PlayForBegin. Triggers a foul, remove_ball and restart_round." do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: 5.579606637080942,
          y: -0.8747776565806149
        }
      }
      shot_hash.deep_stringify_keys!
      shot = Shot.new shot_hash

      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      @table.shoot shot
      current_state = @table.current_state

      shot_results = current_state['shot_results']

      expect(shot_results['shot']).to eq shot_hash
      expect(shot_results['foul']).to be_truthy

      events = shot_results['events'].map do |e|
        e.delete('ball_id')
        e
      end

      expected_events = [
        {
          event: :breakball_falls_into_a_hole,
          advice: 'remove_ball'
        },
        {
          event: :breakball_falls_into_a_hole,
          advice: 'restart_round'
        }
      ]
      expected_events.each {|e| e.deep_stringify_keys!}

      expect(events).to eq expected_events
    end

    it "shoots breakball across the CenterLine in PlayForBegin. Triggers a foul, restart_round." do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: 0.5717777628398706,
          y: 0.49371039723116894
        }
      }
      shot_hash.deep_stringify_keys!
      shot = Shot.new shot_hash

      state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      @table.shoot shot
      current_state = @table.current_state

      shot_results = current_state['shot_results']

      expect(shot_results['shot']).to eq shot_hash
      expect(shot_results['foul']).to be_truthy

      events = shot_results['events'].map do |e|
        e.delete('ball_id')
        e
      end

      expected_events = [
        {
          event: :breakball_crosses_center_line,
          advice: 'restart_round'
        }
      ]
      expected_events.each {|e| e.deep_stringify_keys!}

      expect(events).to eq expected_events
    end

    it "reinstates the breakball at a given position." do
      breaker = @players[:player_1].id

      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForVictory", breaker
      state[:balls].delete_if {|ball| ball[:type] == 'breakball'}
      state.deep_stringify_keys!
      @table.initialize_last_state state

      at_position = {
        x: -Configuration::BallPosition.quarterWidth,
        y: 0
      }
      at_position.deep_stringify_keys!
      result = @table.reinstate at_position

      expect(result['reinstated']).to be_truthy
    end

    it "tries to reinstate the breakball out of table-boundaries." do
      breaker = @players[:player_1].id

      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForVictory", breaker
      state[:balls].delete_if {|ball| ball[:type] == 'breakball'}
      state.deep_stringify_keys!
      @table.initialize_last_state state

      positions = [
        {
          x: -(Configuration::BallPosition.halfWidth + 0.01),
          y: 0
        },
        {
          x: (Configuration::BallPosition.halfWidth + 0.01),
          y: 0
        },
        {
          x: 0,
          y: -(Configuration::BallPosition.quarterWidth + 0.01)
        },
        {
          x: 0,
          y: (Configuration::BallPosition.quarterWidth + 0.01)
        }
      ]

      positions.each do |at_position|
        at_position =
        at_position.deep_stringify_keys!
        result = @table.reinstate at_position

        expect(result['reinstated']).to be_falsy
        expect(result['reasons']).to contain_exactly :position_out_of_table_boundaries
      end
    end

    it "returns its current state" do
      state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForBegin"
      state.deep_stringify_keys!
      @table.initialize_last_state state
      shot_result = {
        shot_results: {}
      }
      shot_result.deep_stringify_keys!
      state.merge!(shot_result)
      expect(@table.current_state).to eq state
    end

    it "raises an error, if we try to get the current_state, but table isn't initialized yet" do
      expect{@table.current_state}.to raise_error "Table isn't initialized yet."
    end
  end
end
