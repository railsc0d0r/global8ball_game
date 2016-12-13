require 'rails_helper'

module Global8ballGame
  RSpec.describe PhysicsConcern, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @config = @object_creator.create_table_config

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

      expect(state).to eql expected_state.deep_stringify_keys
    end

    it "can provide an initial state for PlayForVictory to be saved as last_result." do
      breaker = @game.player_1_id
      state = @game.initial_state @game.player_1_id, @game.player_2_id, "PlayForVictory", breaker
      expected_state = @object_creator.initial_state @game.player_1_id, @game.player_2_id, "PlayForVictory", breaker

      expect(state).to eql expected_state.deep_stringify_keys
    end

    it "can evaluate a shot in PlayForBegin." do
      breaker = @object_creator.players[:player_1].id
      stage_name = 'PlayForBegin'

      @game.initialize_state stage_name, breaker

      shot_hash = {
        user_id: breaker,
        velocity: {
          x: @config[:table][:max_breakball_speed],
          y: 0
        }
      }
      shot_hash.deep_stringify_keys!

      expected_result =
      {
        "current_stage" =>
          {
            "stage_name" => "PlayForBegin",
            "round" => 1
          },
        "balls" =>
          [
            {
              "id" => 1,
              "type" => "breakball",
              "color" => "white",
              "owner" => 1,
              "radius" => 0.0291,
              "mass" => 0.17,
              "position" =>
                {
                  "x" => 0.6559660050258933,
                  "y" => -0.3175
                }
            },
            {
              "id" => 2,
              "type" => "breakball",
              "color" => "white",
              "owner" => 2,
              "radius" => 0.0291,
              "mass" => 0.17,
              "position" =>
                {
                  "x" => -0.635,
                  "y" => 0.3175
                }
            }
          ],
        "current_players" =>
          [
            {"user_id"=>1},
            {"user_id"=>2}
          ],
        "current_results" => [],
        "shot_results" =>
          {
            "shot" =>
              {
                "user_id" => 1,
                "velocity" =>
                  {
                    "x" => 11.295529411764704,
                    "y" => 0
                  }
              },
            "foul" => false,
            "events"=>[]
          }
      }
      result = @game.eval_shot shot_hash

      expect(result).to eql expected_result
    end

    it "handles change_breaker from last_result before returning the current state" do
      breakers = [
        @game.player_1_id,
        @game.player_2_id
      ]

      breakers.each do |breaker|
        state = InitialState.new @game.player_1_id, @game.player_2_id, "PlayForVictory", breaker

        event = {
            event: :breakball_falls_into_a_hole,
            advice: 'change_breaker'
        }
        event.deep_stringify_keys!

        state.shot_results['events'] << event

        @game.last_result = state.to_hash

        current_state = GameState.new @game.get_state
        expected_breaker = breaker == @game.player_1_id ? @game.player_2_id : @game.player_1_id

        expect(current_state.current_players).to eql [{'user_id' => expected_breaker}]
        expect(current_state.shot_results).to eql ShotResult.new.to_hash
      end
    end

    it "handles restart_round from last_result in PlayForBegin" do
      state = InitialState.new @game.player_1_id, @game.player_2_id

      event = {
        event: :breakball_falls_into_a_hole,
        advice: 'restart_round'
      }

      state.shot_results['events'] << event
      state.balls[0]['position']['x'] = 0.635
      @game.last_result = state.to_hash

      current_state = GameState.new @game.get_state
      initial_state = InitialState.new @game.player_1_id, @game.player_2_id

      expect(current_state.balls).to eql initial_state.balls
      expect(current_state.round).to eql 2
      expect(current_state.shot_results).to eql ShotResult.new.to_hash
    end
  end
end
