require 'rails_helper'

module Global8ballGame
  module Event
    RSpec.describe Collision, type: :model do
      before do
        @object_creator = ObjectCreator.new
        @breakball, @playball, @playball2, @eightball, @center_line, @right_border, @right_top_hole = @object_creator.create_bodies_for_collision_events
      end

      it "can be initialized w/ given payload" do
        expect {Collision.new}.to raise_error "No payload given to be initialized"
      end

      it "checks if payload is a hash" do
        expect {Collision.new "Test"}.to raise_error "Payload given has to be a hash of objects"
      end

      it "checks if payload contains two p2-bodies" do
        expect {Collision.new body_a: "Body A", body_b: @playball}.to raise_error "Following bodies are not p2-bodies: body a."
        expect {Collision.new body_a: @breakball, body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body b."
        expect {Collision.new body_a: "Body A", body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body a, body b."
      end

      it "stores given bodies in instance-vars and provides setters to access them" do
        ce = Collision.new body_a: @breakball, body_b: @playball
        expect(ce.body_a).to be @breakball
        expect(ce.body_b).to be @playball
      end

      it "checks if the event contains a breakball" do
        ce = Collision.new body_a: @breakball, body_b: @playball
        expect(ce.contains_breakball).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @breakball
        expect(ce.contains_breakball).to be_truthy
        ce = Collision.new body_a: @playball, body_b: @eightball
        expect(ce.contains_breakball).to be_falsy
      end

      it "checks if the event contains the 8ball" do
        ce = Collision.new body_a: @breakball, body_b: @eightball
        expect(ce.contains_8ball).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @playball
        expect(ce.contains_8ball).to be_falsy
      end

      it "checks if the event contains two balls" do
        ce = Collision.new body_a: @breakball, body_b: @playball
        expect(ce.contains_two_balls).to be_truthy
        ce = Collision.new body_a: @playball, body_b: @playball2
        expect(ce.contains_two_balls).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @center_line
        expect(ce.contains_two_balls).to be_falsy
      end

      it "checks if the event contains only one ball" do
        ce = Collision.new body_a: @breakball, body_b: @center_line
        expect(ce.contains_one_ball).to be_truthy

        ce = Collision.new body_a: @breakball, body_b: @playball
        expect(ce.contains_one_ball).to be_falsy
      end

      it "checks if the event contains the center line" do
        ce = Collision.new body_a: @breakball, body_b: @center_line
        expect(ce.contains_center_line).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.contains_center_line).to be_falsy
      end

      it "checks if the event contains the right border" do
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.contains_right_border).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.contains_right_border).to be_falsy
      end

      it "checks if the event contains a hole" do
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.contains_hole).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.contains_hole).to be_falsy
      end

      it "checks if a ball falls into a hole" do
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.ball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.ball_falls_into_a_hole).to be_falsy
      end

      it "checks if the breakball falls into a hole" do
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.breakball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.breakball_falls_into_a_hole).to be_falsy
        ce = Collision.new body_a: @playball, body_b: @right_top_hole
        expect(ce.breakball_falls_into_a_hole).to be_falsy
      end

      it "checks if the 8ball falls into a hole" do
        ce = Collision.new body_a: @eightball, body_b: @right_top_hole
        expect(ce.eightball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: @eightball, body_b: @right_border
        expect(ce.eightball_falls_into_a_hole).to be_falsy
        ce = Collision.new body_a: @playball, body_b: @right_top_hole
        expect(ce.eightball_falls_into_a_hole).to be_falsy
      end

      it "checks if the breakball crosses the center-line" do
        ce = Collision.new body_a: @breakball, body_b: @center_line
        expect(ce.breakball_crosses_center_line).to be_truthy
        ce = Collision.new body_a: @playball, body_b: @center_line
        expect(ce.breakball_crosses_center_line).to be_falsy
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.breakball_crosses_center_line).to be_falsy
      end

      it "checks if breakball collides w/ eightball" do
        ce = Collision.new body_a: @breakball, body_b: @eightball
        expect(ce.breakball_collides_with_eightball).to be_truthy
      end

      it "returns a symbol describing the evaluated event to be used as searchtag in rules-parsing" do
        ce = Collision.new body_a: @playball, body_b: @right_top_hole
        expect(ce.kind_of_event).to eq :ball_falls_into_a_hole
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.kind_of_event).to eq :breakball_falls_into_a_hole
        ce = Collision.new body_a: @eightball, body_b: @right_top_hole
        expect(ce.kind_of_event).to eq :eightball_falls_into_a_hole
        ce = Collision.new body_a: @breakball, body_b: @center_line
        expect(ce.kind_of_event).to eq :breakball_crosses_center_line
        ce = Collision.new body_a: @breakball, body_b: @eightball
        expect(ce.kind_of_event).to eq :breakball_collides_with_eightball
        ce = Collision.new body_a: @breakball, body_b: @right_border
        expect(ce.kind_of_event).to eq :standard_collision
      end

      it "raises an error, if we try to get a ball but event contains two." do
        ce = Collision.new body_a: @playball, body_b: @breakball
        expect{ce.get_ball}.to raise_error "Don't know which ball to return."
      end

      it "returns the ball, if the event contains only one" do
        ce = Collision.new body_a: @breakball, body_b: @right_top_hole
        expect(ce.get_ball).to be @breakball
        ce = Collision.new body_a: @right_top_hole, body_b: @playball
        expect(ce.get_ball).to be @playball
      end

      it "returns nil, if the event doesn't contain a ball" do
        ce = Collision.new body_a: @center_line, body_b: @right_top_hole
        expect(ce.get_ball).to be nil
      end
    end
  end
end
