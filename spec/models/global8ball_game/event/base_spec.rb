require 'rails_helper'

module Global8ballGame
  module Event
    RSpec.describe Base, type: :model do
      it "can be initialized w/ given payload" do
        expect {Base.new}.to raise_error "No payload given to be initialized"
      end

      it "checks if payload is a hash" do
        expect {Base.new "Test"}.to raise_error "Payload given has to be a hash of objects"
      end
    end
  end
end
