require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesForEveryStage, type: :model do
    before do
      @collision_rules = RulesForEveryStage.new.rules_for :collision_event
      @timeout_rules = RulesForEveryStage.new.rules_for :timeout_event
      @expected_rules = {
        collision_event: [
          {
            searchtags: [:breakball_falls_into_a_hole],
            msg: :breakball_falls_into_a_hole,
            advice: :reinstate_breakball,
            foul: true
          },
          {
            searchtags: [:breakball_falls_into_a_hole, :ball_falls_into_a_hole],
            msg: :ball_falls_into_a_hole,
            advice: :remove_ball,
            foul: false
          }
        ],
        timeout_event: []
      }
    end

    it "returns all rules for a collision_event" do
      expect(@collision_rules).to eq @expected_rules[:collision_event]
    end

    it "returns all rules for a timeout_event" do
      expect(@timeout_rules).to eq @expected_rules[:timeout_event]
    end
  end
end
