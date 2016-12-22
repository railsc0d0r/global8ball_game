require 'rails_helper'

module Global8ballGame
  module Rules
    RSpec.describe ForPlayForBegin, type: :model do
      before do
        @rules_for_play_for_begin = ForPlayForBegin.new
      end

      it "returns all rules given the breakball crosses the center_line" do
        event = :collision
        search_tag = :breakball_crosses_center_line
        expected_result = [
          {
            advice: :round_lost,
            foul: true,
            conditional: false
          }
        ]

        expect(@rules_for_play_for_begin.rules_for event, search_tag).to eq expected_result
      end

      it "returns all rules given the breakball falls into a hole in PlayForBegin" do
        event = :collision
        search_tag = :breakball_falls_into_a_hole
        expected_result = [
          {
            advice: :round_lost,
            foul: true,
            conditional: false
          }
        ]

        expect(@rules_for_play_for_begin.rules_for event, search_tag).to eq expected_result
      end

      it "returns all rules given the breakball touches a side-border in PlayForBegin" do
        event = :collision
        search_tag = :breakball_collides_with_side_border
        expected_result = [
          {
            advice: :round_lost,
            foul: true,
            conditional: false
          }
        ]

        expect(@rules_for_play_for_begin.rules_for event, search_tag).to eq expected_result
      end
    end
  end
end
