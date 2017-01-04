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

    it "stores a stop-timestamp" do
      stop = Time.at(Time.now.since(10).to_i)
      AlarmClock.create game: @game, stop: stop
      expect(AlarmClock.all.first.stop).to be_kind_of Time
      expect(AlarmClock.all.first.stop).to eq stop
    end
  end
end
