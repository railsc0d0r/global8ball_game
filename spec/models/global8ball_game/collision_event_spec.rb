require 'rails_helper'

module Global8ballGame
  RSpec.describe CollisionEvent, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @breakball, @playball, @eightball, @center_line, @right_border, @right_top_hole = @object_creator.create_bodies_for_collision_events
    end

    it "can be initialized w/ given payload" do
      expect {CollisionEvent.new}.to raise_error "No payload given to be initialized"
    end

    it "checks if payload is a hash" do
      expect {CollisionEvent.new "Test"}.to raise_error "Payload given has to be a hash of objects"
    end

    it "checks if payload contains two p2-bodies" do
      expect {CollisionEvent.new body_a: "Body A", body_b: @playball}.to raise_error "Following bodies are not p2-bodies: body a."
      expect {CollisionEvent.new body_a: @breakball, body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body b."
      expect {CollisionEvent.new body_a: "Body A", body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body a, body b."
    end

    it "stores given bodies in instance-vars and provides setters to access them" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @playball
      expect(ce.body_a).to be @breakball
      expect(ce.body_b).to be @playball
    end

    it "checks if the event contains a breakball" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @playball
      expect(ce.contains_breakball).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @breakball
      expect(ce.contains_breakball).to be_truthy
      ce = CollisionEvent.new body_a: @playball, body_b: @eightball
      expect(ce.contains_breakball).to be_falsy
    end

    it "checks if the event contains the 8ball" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @eightball
      expect(ce.contains_8ball).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @playball
      expect(ce.contains_8ball).to be_falsy
    end

    it "checks if the event contains two balls" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @playball
      expect(ce.contains_two_balls).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @center_line
      expect(ce.contains_two_balls).to be_falsy
    end

    it "checks if the event contains only one ball" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @center_line
      expect(ce.contains_one_ball).to be_truthy

      ce = CollisionEvent.new body_a: @breakball, body_b: @playball
      expect(ce.contains_one_ball).to be_falsy
    end

    it "checks if the event contains the center line" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @center_line
      expect(ce.contains_center_line).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.contains_center_line).to be_falsy
    end

    it "checks if the event contains the right border" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.contains_right_border).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_top_hole
      expect(ce.contains_right_border).to be_falsy
    end

    it "checks if the event contains a hole" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_top_hole
      expect(ce.contains_hole).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.contains_hole).to be_falsy
    end

    it "checks if a ball falls into a hole" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_top_hole
      expect(ce.ball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.ball_falls_into_a_hole).to be_falsy
    end

    it "checks if the breakball falls into a hole" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_top_hole
      expect(ce.breakball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.breakball_falls_into_a_hole).to be_falsy
      ce = CollisionEvent.new body_a: @playball, body_b: @right_top_hole
      expect(ce.breakball_falls_into_a_hole).to be_falsy
    end

    it "checks if the 8ball falls into a hole" do
      ce = CollisionEvent.new body_a: @eightball, body_b: @right_top_hole
      expect(ce.eightball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @eightball, body_b: @right_border
      expect(ce.eightball_falls_into_a_hole).to be_falsy
      ce = CollisionEvent.new body_a: @playball, body_b: @right_top_hole
      expect(ce.eightball_falls_into_a_hole).to be_falsy
    end

    it "checks if the breakball crosses the center-line" do
      ce = CollisionEvent.new body_a: @breakball, body_b: @center_line
      expect(ce.breakball_crosses_center_line).to be_truthy
      ce = CollisionEvent.new body_a: @playball, body_b: @center_line
      expect(ce.breakball_crosses_center_line).to be_falsy
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.breakball_crosses_center_line).to be_falsy
    end

    it "returns a symbol from the evaluated event to be used as searchtag in rules-parsing" do
      ce = CollisionEvent.new body_a: @playball, body_b: @right_top_hole
      expect(ce.kind_of_event).to eq :ball_falls_into_a_hole
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_top_hole
      expect(ce.kind_of_event).to eq :breakball_falls_into_a_hole
      ce = CollisionEvent.new body_a: @eightball, body_b: @right_top_hole
      expect(ce.kind_of_event).to eq :eightball_falls_into_a_hole
      ce = CollisionEvent.new body_a: @breakball, body_b: @center_line
      expect(ce.kind_of_event).to eq :breakball_crosses_center_line
      ce = CollisionEvent.new body_a: @breakball, body_b: @right_border
      expect(ce.kind_of_event).to eq nil
    end
  end
end
