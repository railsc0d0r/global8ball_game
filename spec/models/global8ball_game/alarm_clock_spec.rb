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
      finish = Time.at(Time.now.in(5.minutes).to_i)
      AlarmClock.create game: @game, finish: finish
      expect(AlarmClock.all.first.finish).to be_kind_of Time
      expect(AlarmClock.all.first.finish).to eq finish
    end

    it "stores its context" do
      context = :shotclock
      AlarmClock.create game: @game, finish: Time.now, context: context
      result_clock = AlarmClock.all.first

      expect(result_clock.context).to be_kind_of Symbol
      expect(result_clock.context).to eq context
    end

    it "stores the player this alarm_clock belongs to" do
      player = @game.player_1
      alarm_clock = AlarmClock.create game: @game, finish: Time.now, player: player

      expect(AlarmClock.all.first.player).to eq player
    end

    it "provides timestamps on create and update" do
      alarm_clock = AlarmClock.create game: @game, finish: Time.now

      expect(alarm_clock.created_at).to be_kind_of Time
      expect(alarm_clock.updated_at).to be_kind_of Time
    end

    it "can tell if the alarm-time passed already" do
      time_now = Time.now
      finish = Time.at(time_now.in(5.seconds).to_i)
      alarm_clock = AlarmClock.create game: @game, finish: finish

      Timecop.freeze(Time.at(time_now.in(4.seconds).to_i)) do
        expect(alarm_clock.finished?).to be_falsy
      end

      Timecop.freeze(Time.at(time_now.in(5.seconds).to_i)) do
        expect(alarm_clock.finished?).to be_truthy
      end
    end

    it "can check the alarm_clock and publishes an event if the alarm is to be sounded" do
      time_now = Time.now
      finish = Time.at(time_now.in(5.seconds).to_i)
      alarm_clock = AlarmClock.create game: @game, finish: finish
      result = false

      alarm_clock.on(:sound_the_alarm) do
        result = true
      end

      Timecop.freeze(Time.at(time_now.in(4.seconds).to_i)) do
        alarm_clock.check!
        expect(result).to be_falsy
      end

      Timecop.freeze(Time.at(time_now.in(5.seconds).to_i)) do
        alarm_clock.check!
        expect(result).to be_truthy
      end
    end

    it "can add x seconds to finish-timestamp and persist the new timestamp" do
      finish = Time.at(Time.now.in(5.minutes).to_i)
      alarm_clock = AlarmClock.create game: @game, finish: finish
      alarm_clock.add_seconds 20
      expected_result = finish.in(20.seconds)

      expect(AlarmClock.all.first.finish).to eq expected_result
    end
  end
end