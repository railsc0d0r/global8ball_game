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

    it "stores a start-timestamp" do
      start = Time.at(Time.now.to_i)
      StopWatch.create game: @game, start: start
      expect(StopWatch.all.first.start).to be_kind_of Time
      expect(StopWatch.all.first.start).to eq start
    end

    it "stores a stop-timestamp" do
      stop = Time.at(Time.now.since(10).to_i)
      StopWatch.create game: @game, stop: stop
      expect(StopWatch.all.first.stop).to be_kind_of Time
      expect(StopWatch.all.first.stop).to eq stop
    end
  end
end
