require 'rails_helper'

module Global8ballGame
  module Physics
    RSpec.describe Border, type: :model do
      before do
        @key = 'leftBottom'
        @vertices = [
          [-1.259416589, -0.6932],
          [-0.047625347, -0.6932],
          [-0.066146316, -0.635],
          [-1.187978569, -0.635]
        ]
        @material = P2PhysicsWrapper::P2.Material.new

        @border = Border.new @key, @vertices, @material
      end

      it "has a body w/ a convex shape." do
        expect(@border.body.shapes[0]['constructor']['name']).to eq "Convex"
      end

      it "initializes a body w/ given vertices." do
        expect(@border.body.shapes[0].vertices.map{|v| v.to_a}).to eq @vertices
      end

      it "has a body initialized w/ body_type 'ball'" do
        expect(@border.body.body_type).to eq "border"
      end

      it "has a body initialized w/ a given key" do
        expect(@border.body.key).to eq @key
      end

      it "has a body initialized as STATIC" do
        expect(@border.body.type).to eq P2PhysicsWrapper::P2.Body.STATIC
      end

      it "has a shape w/ a given contact_material" do
        expect(@border.body.shapes[0].material).to be @material
      end
    end
  end
end
