require 'rails_helper'

module Global8ballGame
  RSpec.describe StopWatch, type: :model do
    before do
      object_creator = ObjectCreator.new
      @game = Game.create!
    end

    it "belongs to a Game" do
      StopWatch.create game: @game
      expect(StopWatch.all.first.game).to eq @game
    end

  end
end
