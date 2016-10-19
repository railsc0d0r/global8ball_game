require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesForPlayForVictory, type: :model do
    before do
      @rules_for_play_for_victory = RulesForPlayForVictory.new
    end

    it "returns all rules given the eightball falls into a hole" do
      event = :collision_event
      search_tag = :eightball_falls_into_a_hole
      expected_result = [
        {
          msg: :eightball_falls_into_a_hole,
          advice: :round_lost,
          foul: true,
          conditional: true
        }
      ]

      expect(@rules_for_play_for_victory.rules_for event, search_tag).to eq expected_result
    end

  end
end
