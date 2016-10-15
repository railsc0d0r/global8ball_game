require 'rails_helper'

module Global8ballGame
  RSpec.describe RuleBook, type: :model do
    it "returns a hash of all rules. This is empty because it's just the base class." do
      rules = {
            fictional_event: []
          }

      expect(RuleBook.new.all_rules).to be
      expect(RuleBook.new.all_rules).to be_instance_of Hash
    end

    it "returns an array of rules when given an event-type. This is empty because it's just the base class." do
      expect(RuleBook.new.rules_for :fictional_event).to be_empty
      expect(RuleBook.new.rules_for :fictional_event).to be_instance_of Array
    end

    it "returns an array of rules when given an event-type and a search_tag." do
      expect(RuleBook.new.rules_for :fictional_event, :search_tag).to be_instance_of Array
    end
  end
end
