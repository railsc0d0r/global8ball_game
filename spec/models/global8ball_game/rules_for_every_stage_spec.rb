require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesForEveryStage, type: :model do
    before do
      @rules_for_every_stage = RulesForEveryStage.new
    end

    it "returns all rules given the breakball falls into a hole" do
      event = :collision_event
      search_tag = :breakball_falls_into_a_hole
      expected_result = [
        {
          msg: :breakball_falls_into_a_hole,
          advice: :reinstate_breakball,
          foul: true,
          conditional: false
        },
        {
          msg: :ball_falls_into_a_hole,
          advice: :remove_ball,
          foul: false,
          conditional: false
        }
      ]

      expect(@rules_for_every_stage.rules_for event, search_tag).to eq expected_result
    end

    it "returns all rules given a ball falls into a hole" do
      event = :collision_event
      search_tag = :ball_falls_into_a_hole
      expected_result = [
        {
          msg: :ball_falls_into_a_hole,
          advice: :remove_ball,
          foul: false,
          conditional: false
        }
      ]

      expect(@rules_for_every_stage.rules_for event, search_tag).to eq expected_result
    end
  end
end
