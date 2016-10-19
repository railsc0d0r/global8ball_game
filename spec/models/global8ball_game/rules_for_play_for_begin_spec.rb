require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesForPlayForBegin, type: :model do
    before do
      @rules_for_play_for_begin = RulesForPlayForBegin.new
    end

    it "returns all rules given the breakball crosses the center_line" do
      event = :collision_event
      search_tag = :breakball_crosses_center_line
      expected_result = [
        {
          msg: :breakball_crosses_center_line,
          advice: :restart_round,
          foul: true,
          conditional: false
        }
      ]

      expect(@rules_for_play_for_begin.rules_for event, search_tag).to eq expected_result
    end


  end
end
