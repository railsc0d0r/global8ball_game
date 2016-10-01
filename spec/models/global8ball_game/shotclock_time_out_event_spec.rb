require 'rails_helper'

module Global8ballGame
  RSpec.describe ShotclockTimeOutEvent, type: :model do
    it "can be initialized w/ given payload" do
      expect {ShotclockTimeOutEvent.new}.to raise_error "No payload given to be initialized"
    end

    it "checks if payload is a hash" do
      expect {ShotclockTimeOutEvent.new "Test"}.to raise_error "Payload given has to be a hash of objects"
    end
  end
end
