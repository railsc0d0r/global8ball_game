require 'rails_helper'

module Global8ballGame
  module Event
    RSpec.describe Collision, type: :model do
      before do
        @object_creator = ObjectCreator.new
        @bodies = @object_creator.create_bodies_for_collision_events
      end

      it "can be initialized w/ given payload" do
        expect {Collision.new}.to raise_error "No payload given to be initialized"
      end

      it "checks if payload is a hash" do
        expect {Collision.new "Test"}.to raise_error "Payload given has to be a hash of objects"
      end

      it "checks if payload contains two p2-bodies" do
        expect {Collision.new body_a: "Body A", body_b: @bodies[:balls][:playball]}.to raise_error "Following bodies are not p2-bodies: body a."
        expect {Collision.new body_a: @bodies[:balls][:breakball], body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body b."
        expect {Collision.new body_a: "Body A", body_b: "Body B"}.to raise_error "Following bodies are not p2-bodies: body a, body b."
      end

      it "stores given bodies in instance-vars and provides setters to access them" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]

        ce = Collision.new body_a: breakball, body_b: playball
        expect(ce.body_a).to be breakball
        expect(ce.body_b).to be playball
      end

      it "checks if the event contains a breakball" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        eightball = @bodies[:balls][:eightball]

        ce = Collision.new body_a: breakball, body_b: playball
        expect(ce.contains_breakball).to be_truthy
        ce = Collision.new body_a: breakball, body_b: breakball
        expect(ce.contains_breakball).to be_truthy
        ce = Collision.new body_a: playball, body_b: eightball
        expect(ce.contains_breakball).to be_falsy
      end

      it "checks if the event contains the 8ball" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        eightball = @bodies[:balls][:eightball]

        ce = Collision.new body_a: breakball, body_b: eightball
        expect(ce.contains_8ball).to be_truthy
        ce = Collision.new body_a: breakball, body_b: playball
        expect(ce.contains_8ball).to be_falsy
      end

      it "checks if the event contains two balls" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        playball_2 = @bodies[:balls][:playball_2]
        center_line = @bodies[:center_line]

        ce = Collision.new body_a: breakball, body_b: playball
        expect(ce.contains_two_balls).to be_truthy
        ce = Collision.new body_a: playball, body_b: playball_2
        expect(ce.contains_two_balls).to be_truthy
        ce = Collision.new body_a: breakball, body_b: center_line
        expect(ce.contains_two_balls).to be_falsy
      end

      it "checks if the event contains only one ball" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        center_line = @bodies[:center_line]

        ce = Collision.new body_a: breakball, body_b: center_line
        expect(ce.contains_one_ball).to be_truthy

        ce = Collision.new body_a: breakball, body_b: playball
        expect(ce.contains_one_ball).to be_falsy
      end

      it "checks if the event contains the center line" do
        breakball = @bodies[:balls][:breakball]
        center_line = @bodies[:center_line]
        right_border = @bodies[:borders][:right_border]

        ce = Collision.new body_a: breakball, body_b: center_line
        expect(ce.contains_center_line).to be_truthy
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.contains_center_line).to be_falsy
      end

      it "checks if the event contains the right border" do
        breakball = @bodies[:balls][:breakball]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.contains_right_border).to be_truthy
        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.contains_right_border).to be_falsy
      end

      it "checks if the event contains the left border" do
        breakball = @bodies[:balls][:breakball]
        left_border = @bodies[:borders][:left_border]
        left_top_hole = @bodies[:holes][:left_top_hole]

        ce = Collision.new body_a: breakball, body_b: left_border
        expect(ce.contains_left_border).to be_truthy
        ce = Collision.new body_a: breakball, body_b: left_top_hole
        expect(ce.contains_left_border).to be_falsy
      end

      it "checks if the event contains a hole" do
        breakball = @bodies[:balls][:breakball]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.contains_hole).to be_truthy
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.contains_hole).to be_falsy
      end

      it "checks if a ball falls into a hole" do
        breakball = @bodies[:balls][:breakball]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.ball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.ball_falls_into_a_hole).to be_falsy
      end

      it "checks if the breakball falls into a hole" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.breakball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.breakball_falls_into_a_hole).to be_falsy
        ce = Collision.new body_a: playball, body_b: right_top_hole
        expect(ce.breakball_falls_into_a_hole).to be_falsy
      end

      it "checks if the 8ball falls into a hole" do
        eightball = @bodies[:balls][:eightball]
        playball = @bodies[:balls][:playball]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: eightball, body_b: right_top_hole
        expect(ce.eightball_falls_into_a_hole).to be_truthy
        ce = Collision.new body_a: eightball, body_b: right_border
        expect(ce.eightball_falls_into_a_hole).to be_falsy
        ce = Collision.new body_a: playball, body_b: right_top_hole
        expect(ce.eightball_falls_into_a_hole).to be_falsy
      end

      it "checks if the breakball crosses the center-line" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        right_border = @bodies[:borders][:right_border]
        center_line = @bodies[:center_line]

        ce = Collision.new body_a: breakball, body_b: center_line
        expect(ce.breakball_crosses_center_line).to be_truthy
        ce = Collision.new body_a: playball, body_b: center_line
        expect(ce.breakball_crosses_center_line).to be_falsy
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.breakball_crosses_center_line).to be_falsy
      end

      it "checks if breakball collides w/ eightball" do
        breakball = @bodies[:balls][:breakball]
        eightball = @bodies[:balls][:eightball]

        ce = Collision.new body_a: breakball, body_b: eightball
        expect(ce.breakball_collides_with_eightball).to be_truthy
      end

      it "returns a symbol describing the evaluated event to be used as searchtag in rules-parsing" do
        breakball = @bodies[:balls][:breakball]
        eightball = @bodies[:balls][:eightball]
        playball = @bodies[:balls][:playball]
        center_line = @bodies[:center_line]
        right_border = @bodies[:borders][:right_border]
        right_top_hole = @bodies[:holes][:right_top_hole]
        left_border = @bodies[:borders][:left_border]

        ce = Collision.new body_a: playball, body_b: right_top_hole
        expect(ce.kind_of_event).to eq :ball_falls_into_a_hole
        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.kind_of_event).to eq :breakball_falls_into_a_hole
        ce = Collision.new body_a: eightball, body_b: right_top_hole
        expect(ce.kind_of_event).to eq :eightball_falls_into_a_hole
        ce = Collision.new body_a: breakball, body_b: center_line
        expect(ce.kind_of_event).to eq :breakball_crosses_center_line
        ce = Collision.new body_a: breakball, body_b: eightball
        expect(ce.kind_of_event).to eq :breakball_collides_with_eightball
        ce = Collision.new body_a: breakball, body_b: right_border
        expect(ce.kind_of_event).to eq :standard_collision
      end

      it "raises an error, if we try to get a ball but event contains two." do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]

        ce = Collision.new body_a: playball, body_b: breakball
        expect{ce.get_ball}.to raise_error "Don't know which ball to return."
      end

      it "returns the ball, if the event contains only one" do
        breakball = @bodies[:balls][:breakball]
        playball = @bodies[:balls][:playball]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: breakball, body_b: right_top_hole
        expect(ce.get_ball).to be breakball
        ce = Collision.new body_a: right_top_hole, body_b: playball
        expect(ce.get_ball).to be playball
      end

      it "returns nil, if the event doesn't contain a ball" do
        center_line = @bodies[:center_line]
        right_top_hole = @bodies[:holes][:right_top_hole]

        ce = Collision.new body_a: center_line, body_b: right_top_hole
        expect(ce.get_ball).to be nil
      end
    end
  end
end
