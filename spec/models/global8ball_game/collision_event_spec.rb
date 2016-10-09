require 'rails_helper'

module Global8ballGame
  RSpec.describe CollisionEvent, type: :model do
    before do
      @breakball, @playball, @eightball, @center_line, @right_border, @right_top_hole = create_bodies_for_collission_events
    end

    it "can be initialized w/ given payload" do
      expect {CollisionEvent.new}.to raise_error "No payload given to be initialized"
    end

    it "checks if payload is a hash" do
      expect {CollisionEvent.new "Test"}.to raise_error "Payload given has to be a hash of objects"
    end

    it "checks if payload contains two p2-bodies" do
      expect {CollisionEvent.new body_a: "Body A", body_b: @ball_b}.to raise_error "Following bodies are not p2-bodies: body a."
      expect {CollisionEvent.new body_a: @ball_a, body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body b."
      expect {CollisionEvent.new body_a: "Body A", body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body a, body b."
    end

    it "stores given bodies in instance-vars and provides setters to access them" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.body_a).to be @ball_a
      expect(ce.body_b).to be @ball_b
    end

    it "checks if the event contains a breakball" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.contains_breakball).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_a
      expect(ce.contains_breakball).to be_truthy
      ce = CollisionEvent.new body_a: @ball_b, body_b: @ball_c
      expect(ce.contains_breakball).to be_falsy
    end

    it "checks if the event contains the 8ball" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_c
      expect(ce.contains_8ball).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.contains_8ball).to be_falsy
    end

    it "checks if the event contains two balls" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.contains_two_balls).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @center_line
      expect(ce.contains_two_balls).to be_falsy
    end

    it "checks if the event contains only one ball" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @center_line
      expect(ce.contains_one_ball).to be_truthy

      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.contains_one_ball).to be_falsy
    end

    it "checks if the event contains the center line" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @center_line
      expect(ce.contains_center_line).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.contains_center_line).to be_falsy
    end

    it "checks if the event contains the right border" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.contains_right_border).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.contains_right_border).to be_falsy
    end

    it "checks if the event contains a hole" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.contains_hole).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.contains_hole).to be_falsy
    end

    it "checks if a ball falls into a hole" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.ball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.ball_falls_into_a_hole).to be_falsy
    end

    it "checks if the breakball falls into a hole" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.breakball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.breakball_falls_into_a_hole).to be_falsy
      ce = CollisionEvent.new body_a: @ball_b, body_b: @right_top_hole
      expect(ce.breakball_falls_into_a_hole).to be_falsy
    end

    it "checks if the 8ball falls into a hole" do
      ce = CollisionEvent.new body_a: @ball_c, body_b: @right_top_hole
      expect(ce.eightball_falls_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @ball_c, body_b: @right_border
      expect(ce.eightball_falls_into_a_hole).to be_falsy
      ce = CollisionEvent.new body_a: @ball_b, body_b: @right_top_hole
      expect(ce.eightball_falls_into_a_hole).to be_falsy
    end

    it "checks if the breakball crosses the center-line" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @center_line
      expect(ce.breakball_crosses_center_line).to be_truthy
      ce = CollisionEvent.new body_a: @ball_b, body_b: @center_line
      expect(ce.breakball_crosses_center_line).to be_falsy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.breakball_crosses_center_line).to be_falsy
    end
  end
end
