require 'rails_helper'

module Global8ballGame
  module Physics
    RSpec.describe Hole, type: :model do
      before do
        @key = 'leftTop'
        @radius = 0.018525347
        @position = [-1.2991, 0.6641]

        @hole = Hole.new @key, @radius, @position
      end

      it "has a body w/ a circular shape and a given radius." do
        expect(@hole.body.shapes[0]['constructor']['name']).to eq "Circle"
        expect(@hole.body.shapes[0].radius).to eq @radius
      end

      it "has a body initialized w/ body_type 'ball'" do
        expect(@hole.body.body_type).to eq "hole"
      end

      it "has a body initialized w/ a given key" do
        expect(@hole.body.key).to eq @key
      end

      it "has a body initialized w/ a given position" do
        expect(@hole.body.position.to_a).to eq @position
      end

      it "has a body initialized as STATIC" do
        expect(@hole.body.type).to eq P2PhysicsWrapper::P2.Body.STATIC
      end
    end
  end
end
