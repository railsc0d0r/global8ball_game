require 'rails_helper'

module Global8ballGame
  module Rules
    RSpec.describe ForEveryStage, type: :model do
      before do
        @rules_for_every_stage = ForEveryStage.new
      end

      it "returns all rules given the breakball falls into a hole" do
        event = :collision
        search_tag = :breakball_falls_into_a_hole
        expected_result = [
          {
            advice: :remove_ball,
            foul: false,
            conditional: false
          }
        ]

        expect(@rules_for_every_stage.rules_for event, search_tag).to eq expected_result
      end

      it "returns all rules given the eightball falls into a hole" do
        event = :collision
        search_tag = :eightball_falls_into_a_hole
        expected_result = [
          {
            advice: :remove_ball,
            foul: false,
            conditional: false
          }
        ]

        expect(@rules_for_every_stage.rules_for event, search_tag).to eq expected_result
      end

      it "returns all rules given a ball falls into a hole" do
        event = :collision
        search_tag = :ball_falls_into_a_hole
        expected_result = [
          {
            advice: :remove_ball,
            foul: false,
            conditional: false
          }
        ]

        expect(@rules_for_every_stage.rules_for event, search_tag).to eq expected_result
      end
    end
  end
end
