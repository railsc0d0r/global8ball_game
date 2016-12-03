require 'rails_helper'

module Global8ballGame
  RSpec.describe GameState, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players

      @state = @object_creator.initial_state @players[:player_1].id, @players[:player_2].id, "PlayForBegin"
      @state.deep_stringify_keys!

      @gs = GameState.new @state
    end

    it "takes a state and stores its values as attributes" do
      expect(@gs.stage_name).to eq @state['current_stage']['stage_name']
      expect(@gs.round).to eq @state['current_stage']['round']
      expect(@gs.balls).to be @state['balls']
      expect(@gs.current_players).to eq @state['current_players']
      expect(@gs.current_results).to eq @state['current_results']
    end

    it "lets round be overwritten" do
      round = 2
      @gs.round = round
      expect(@gs.round).not_to eq @state['current_stage']['round']
      expect(@gs.round).to eq round
    end

    it "lets balls be overwritten" do
      balls = [
        {
          "id" => 1,
          "type" => "breakball",
          "color" => "white",
          "owner" => 1,
          "radius" => 0.0291,
          "mass" => 0.17,
          "position" => {
            "x" => -0.635,
            "y" => 0
          }
        }
      ]

      @gs.balls = balls
      expect(@gs.balls).to eq balls
    end

    it "lets current_players be overwritten" do
      current_players = [
        {
          "user_id" => 2
        }
      ]

      @gs.current_players = current_players
      expect(@gs.current_players).not_to eq @state['current_players']
      expect(@gs.current_players).to eq current_players
    end

    it "lets current_results be overwritten" do
      current_results = [
        {
            "stage_name" => "PlayForBegin",
                "winner" => 1
        }
      ]

      @gs.current_results = current_results
      expect(@gs.current_results).not_to eq @state['current_results']
      expect(@gs.current_results).to eq current_results
    end

    it "initializes shot_results as empty hash" do
      expect(@gs.shot_results).to be_kind_of Hash
      expect(@gs.shot_results).to be_empty
    end

    it "lets shot_results to be overwritten" do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: 5.579606637080942,
          y: -0.8747776565806149
        }
      }
      shot_hash.deep_stringify_keys!

      events = []

      event = {
        ball_id: 1,
        event: 'ball falls into hole',
        advice: 'remove_ball'
      }
      event.deep_stringify_keys!
      events << event

      event = {
        ball_id: 2,
        event: 'breakball falls into hole',
        advice: 'reinstate_breakball'
      }

      event.deep_stringify_keys!
      events << event

      foul = true

      shot_results = {
        shot_results: {
          shot: shot_hash,
          foul: foul,
          events: events
        }
      }

      shot_results.deep_stringify_keys!
      @gs.shot_results = shot_results

      expect(@gs.shot_results).to eq shot_results
    end

    it "returns its attributes as a hash in the format it received on initialize" do
      shot_results = {
        shot_results: {}
      }
      shot_results.deep_stringify_keys!
      result_hash = @state.merge(shot_results)
      expect(@gs.to_hash).to eq result_hash
    end
  end
end
