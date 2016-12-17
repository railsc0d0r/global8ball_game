require 'rails_helper'

module Global8ballGame
  module Physics
    RSpec.describe Ball, type: :model do
      before do
        @key = 1
        @owner = 1
        @ball_type = "breakball"
        @color = 'white'
        @damping = 0.2
        @mass = 0.17
        @radius = 0.0291
        @position = [0,0]
        @material = P2PhysicsWrapper::P2.Material.new

        @ball = Ball.new @key, @owner, @ball_type, @color, @damping, @mass, @radius, @position, @material
      end

      it "has a body w/ a circular shape and a given radius." do
        expect(@ball.body.shapes[0]['constructor']['name']).to eq "Circle"
        expect(@ball.body.shapes[0].radius).to eq @radius
      end

      it "has a body initialized w/ body_type 'ball'" do
        expect(@ball.body.body_type).to eq "ball"
      end

      it "has a body initialized w/ a given key" do
        expect(@ball.body.key).to eq @key
      end

      it "has a body initialized w/ a given owner-id" do
        expect(@ball.body.owner).to eq @owner
      end

      it "has a body initialized w/ a given ball_type" do
        expect(@ball.body.ball_type).to eq @ball_type
      end

      it "has a body initialized w/ a given color" do
        expect(@ball.body.color).to eq @color
      end

      it "has a body initialized w/ a given value for damping." do
        expect(@ball.body.damping).to eq @damping
      end

      it "has a body initialized w/ a given mass" do
        expect(@ball.body.mass).to eq @mass
      end

      it "has a body initialized w/ a given position" do
        expect(@ball.body.position.to_a).to eq @position
      end

      it "has a shape w/ a given contact_material" do
        expect(@ball.body.shapes[0].material).to be @material
      end

      it "has a body w/ ccdSpeedThreshold set to 1" do
        expect(@ball.body.ccdSpeedThreshold).to eq 1
      end

      it "has a body w/ ccdIterations set to 2" do
        expect(@ball.body.ccdIterations).to eq 2
      end
    end
  end
end
