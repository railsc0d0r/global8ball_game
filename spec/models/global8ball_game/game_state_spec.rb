require 'rails_helper'

module Global8ballGame
  RSpec.describe GameState, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players

      @state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForBegin"
      @state.deep_stringify_keys!

      @gs = GameState.new @state
    end

    it "takes a state and stores its values w/o balls" do
      expect(@gs.stage_name).to eq @state['current_stage']['stage_name']
      expect(@gs.round).to eq @state['current_stage']['round']
      expect(@gs.balls).to be nil
      expect(@gs.current_players).to eq @state['current_players']
      expect(@gs.current_results).to eq @state['current_results']
    end

    it "lets round to be overwritten" do
      round = 1
      @gs.round = round
      expect(@gs.round).not_to eq @state['current_stage']['round']
      expect(@gs.round).to eq round
    end

    it "lets balls to be overwritten" do
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
      expect(@gs.balls).not_to be nil
      expect(@gs.balls).to eq balls
    end

    it "lets current_players to be overwritten" do
      current_players = [
        {
          "user_id" => 2
        }
      ]

      @gs.current_players = current_players
      expect(@gs.current_players).not_to eq @state['current_players']
      expect(@gs.current_players).to eq current_players
    end

    it "lets current_results to be overwritten" do
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
  end
end
