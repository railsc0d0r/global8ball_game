require 'rails_helper'

module Global8ballGame
  RSpec.describe CollisionEvent, type: :model do
    before do
      @body_a = P2PhysicsWrapper::P2.Body.new
      @body_b = P2PhysicsWrapper::P2.Body.new
    end

    it "can be initialized w/ given payload" do
      expect {CollisionEvent.new}.to raise_error "No payload given to be initialized"
    end

    it "checks if payload is a hash" do
      expect {CollisionEvent.new "Test"}.to raise_error "Payload given has to be a hash of objects"
    end

    it "checks if payload contains two p2-bodies" do
      expect {CollisionEvent.new body_a: "Body A", body_b: @body_b}.to raise_error "Body A is not a p2-body."
      expect {CollisionEvent.new body_a: @body_a, body_b: "Body B"}.to raise_error "Body B is not a p2-body."
    end

    it "stores given bodies in instance-vars and provides setters to access them" do
      ce = CollisionEvent.new body_a: @body_a, body_b: @body_b
      expect(ce.body_a).to be @body_a
      expect(ce.body_b).to be @body_b
    end
  end
end
