require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesForEveryStage, type: :model do
    before do
      @rules_for_every_stage = RulesForEveryStage.new
      @expected_rules = {
        collision_event: [
          {
            searchtags: [:breakball_falls_into_a_hole],
            msg: :breakball_falls_into_a_hole,
            advice: :reinstate_breakball,
            foul: true,
            conditional: false
          },
          {
            searchtags: [:breakball_falls_into_a_hole, :ball_falls_into_a_hole],
            msg: :ball_falls_into_a_hole,
            advice: :remove_ball,
            foul: false,
            conditional: false
          }
        ],
        timeout_event: []
      }
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
  end
end
