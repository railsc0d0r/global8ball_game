require 'rails_helper'

module Global8ballGame
  RSpec.describe AlarmClock, type: :model do
    before do
      object_creator = ObjectCreator.new
      @game = Game.create!
    end

    it "belongs to a Game" do
      AlarmClock.create game: @game
      expect(AlarmClock.all.first.game).to eq @game
    end

    it "stores a finish-timestamp" do
      finish = Time.at(Time.now.since(10).to_i)
      AlarmClock.create game: @game, finish: finish
      expect(AlarmClock.all.first.finish).to be_kind_of Time
      expect(AlarmClock.all.first.finish).to eq finish
    end
  end
end
