require 'rails_helper'

module Global8ballGame
  module Rules
    RSpec.describe ForPlayForVictory, type: :model do
      before do
        @rules_for_play_for_victory = ForPlayForVictory.new
      end

      it "returns all rules given the eightball falls into a hole" do
        event = :collision
        search_tag = :eightball_falls_into_a_hole
        expected_result = [
          {
            msg: :round_lost,
            advice: :round_lost,
            foul: true,
            conditional: true,
            condition: :breaker_is_not_eightball_owner
          },
          {
            msg: :round_won,
            advice: :round_won,
            foul: false,
            conditional: true,
            condition: :breaker_is_eightball_owner
          }
        ]

        expect(@rules_for_play_for_victory.rules_for event, search_tag).to eq expected_result
      end

    end
  end
end
