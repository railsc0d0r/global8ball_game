require 'rails_helper'

module Global8ballGame
  RSpec.describe RuleBook, type: :model do
    before do
      @rules = {
        fictional_event: []
      }
      @rule_book = RuleBook.new
    end

    it "returns a hash of all rules." do
      expect(@rule_book.all_rules).to eq @rules
      expect(@rule_book.all_rules).to be_instance_of Hash
    end

    it "returns an array of rules when given an event-type. This is empty because it's just the base class." do
      expect(@rule_book.rules_for :fictional_event).to be_empty
      expect(@rule_book.rules_for :fictional_event).to be_instance_of Array
    end

    it "returns an array of rules when given an event-type and a search_tag." do
      expect(@rule_book.rules_for :fictional_event, :search_tag).to be_empty
      expect(@rule_book.rules_for :fictional_event, :search_tag).to be_instance_of Array
    end
  end
end
