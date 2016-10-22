require 'rails_helper'

module Global8ballGame
  RSpec.describe CenterLine, type: :model do
    before do
      @cl = CenterLine.new
    end

    it "creates a line spanning the table dividing it horizontally by half." do
      expect(@cl.body.body_type).to eq "line"
      expect(@cl.body.shapes[0]['constructor']['name']).to eq "Line"
      expect(@cl.body.position.to_a).to eq [0,0]
      expect(@cl.body.shapes[0].length).to eq 2.54
    end

    it "lets line collide w/ balls but disabling responses thou letting them trough." do
      expect(@cl.body.shapes[0].collisionGroup).to eq 2 ** 5
      expect(@cl.body.shapes[0].collisionMask).to eq 2 ** 4
      expect(@cl.body.shapes[0].collisionResponse).to be_falsy
    end
  end
end
