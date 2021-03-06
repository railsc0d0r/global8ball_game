require 'rails_helper'

module Global8ballGame
  module Rules
    RSpec.describe Book, type: :model do
      before do
        @rules = {
          fictional_event: []
        }
        @rule_book = Book.new
      end

      it "returns a hash of all rules." do
        expect(@rule_book.all_rules).to eq @rules
        expect(@rule_book.all_rules).to be_instance_of Hash
      end

      it "raises an ArgumentError if not given event and searchtag" do
        expect{@rule_book.rules_for :fictional_event}.to raise_error(ArgumentError)
      end

      it "returns an array of rules when given an event-type and a search_tag." do
        expect(@rule_book.rules_for :fictional_event, :search_tag).to be_empty
        expect(@rule_book.rules_for :fictional_event, :search_tag).to be_instance_of Array
      end
    end
  end
end
