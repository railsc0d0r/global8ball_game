require 'rails_helper'

module Global8ballGame
  RSpec.describe CollisionEvent, type: :model do
    before do
      body_type = "ball"
      key = 1
      body_options = {
        mass: 0.7,
        position: [0, 0],
        angle: 0,
        velocity: [0, 0],
        angularVelocity: 0
      }

      @ball_a = create_body body_type, key, body_options
      @ball_a.ball_type = "breakball"

      key = 2
      @ball_b = create_body body_type, key, body_options
      @ball_b.ball_type = "playball"

      key = 3
      @ball_c = create_body body_type, key, body_options
      @ball_c.ball_type = "8ball"

      key = "center"
      body_type = "line"
      @center_line = create_body body_type, key, body_options

      key = "right"
      body_type = "border"
      @right_border = create_body body_type, key, body_options

      key = "rightTop"
      body_type = "hole"
      @right_top_hole = create_body body_type, key, body_options
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
    end

    it "checks if the event contains the 8ball" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_c
      expect(ce.contains_8ball).to be_truthy
    end

    it "checks if the event contains two balls" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @ball_b
      expect(ce.contains_two_balls).to be_truthy
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
    end

    it "checks if the event contains the right border" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.contains_right_border).to be_truthy
    end

    it "checks if the event contains a hole" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.contains_hole).to be_truthy
    end

    it "checks if a ball goes into a hole" do
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_top_hole
      expect(ce.ball_goes_into_a_hole).to be_truthy
      ce = CollisionEvent.new body_a: @ball_a, body_b: @right_border
      expect(ce.ball_goes_into_a_hole).to be_falsy
    end
  end
end
