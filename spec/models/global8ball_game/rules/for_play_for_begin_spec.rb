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
            advice: :restart_round,
            foul: true,
            conditional: false
          }
        ]

        expect(@rules_for_play_for_begin.rules_for event, search_tag).to eq expected_result
      end


    end
  end
end
