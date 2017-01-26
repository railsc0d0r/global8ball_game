require 'rails_helper'

module Global8ballGame
  RSpec.describe AlarmClock, type: :model do
    before do
      object_creator = ObjectCreator.new
      @player_1 = object_creator.players[:player_1]
      @player_2 = object_creator.players[:player_2]
      @game = Game.create player_1_id: @player_1.id, player_1_name: @player_1.name, player_2_id: @player_2.id, player_2_name: @player_2.name
      @time_now = Time.now
      @finish = Time.at(@time_now.in(5.seconds).to_i)
      @context = :shotclock

      @alarm_clock = AlarmClock.create game: @game, finish: @finish, context: @context, player: @player_1
    end

    it "belongs to a Game" do
      expect(AlarmClock.all.first.game).to eq @game
    end

    it "validates presence of Game" do
      expect {result_clock = AlarmClock.create finish: @finish, context: @context, player: @player_1}.to raise_error "Global8ballGame::AlarmClock is not valid. Errors: game_id is not present."
    end

    it "stores a finish-timestamp" do
      result_clock = AlarmClock.all.first

      expect(result_clock.finish).to be_kind_of Time
      expect(result_clock.finish).to eq @finish
    end

    it "validates presence of :finish" do
      expect {AlarmClock.create game: @game, context: @context, player: @player_1}.to raise_error "Global8ballGame::AlarmClock is not valid. Errors: finish is not present."
    end

    it "stores its context" do
      result_clock = AlarmClock.all.first

      expect(result_clock.context).to be_kind_of Symbol
      expect(result_clock.context).to eq @context
    end

    it "validates presence of :context" do
      expect {AlarmClock.create game: @game, finish: @finish, player: @player_1}.to raise_error "Global8ballGame::AlarmClock is not valid. Errors: context is not present."
    end

    it "stores the player this alarm_clock belongs to" do
      expect(AlarmClock.all.first.player).to eq @player_1
    end

    it "validates presence of :player" do
      expect {AlarmClock.create game: @game, finish: @finish, context: @context}.to raise_error "Global8ballGame::AlarmClock is not valid. Errors: player_id is not present."
    end

    it "provides timestamps on create and update" do
      expect(@alarm_clock.created_at).to be_kind_of Time
      expect(@alarm_clock.updated_at).to be_kind_of Time
    end

    it "can tell if the alarm-time passed already" do
      Timecop.freeze(@time_now.in(4.seconds)) do
        expect(@alarm_clock.finished?).to be_falsy
      end

      Timecop.freeze(@time_now.in(5.seconds)) do
        expect(@alarm_clock.finished?).to be_truthy
      end
    end

    it "can check the alarm_clock and publishes an event if the alarm is to be sounded" do
      result = false

      @alarm_clock.on(:sound_the_alarm) do
        result = true
      end

      Timecop.freeze(@time_now.in(4.seconds)) do
        @alarm_clock.check!
        expect(result).to be_falsy
      end

      Timecop.freeze(@time_now.in(5.seconds)) do
        @alarm_clock.check!
        expect(result).to be_truthy
      end
    end

    it "can add x seconds to finish-timestamp and persist the new timestamp" do
      @alarm_clock.add_seconds 20
      expected_result = @finish.in(20.seconds)

      expect(AlarmClock.all.first.finish).to eq expected_result
    end
  end
end
