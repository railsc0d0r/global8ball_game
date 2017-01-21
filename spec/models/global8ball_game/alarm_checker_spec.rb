require 'rails_helper'
require 'alarm_clock_notifier'

module Global8ballGame
  RSpec.describe AlarmChecker, type: :model do
    before do
      object_creator = ObjectCreator.new
      player_1 = object_creator.players[:player_1]
      player_2 = object_creator.players[:player_2]

      @time_now = Time.now
      finish = Time.at(@time_now.in(5.seconds).to_i)
      context = :shotclock

      2.times do
        game = Game.create player_1_id: player_1.id, player_1_name: player_1.name, player_2_id: player_2.id, player_2_name: player_2.name
        AlarmClock.create game: game, finish: finish, context: context, player: player_1
        AlarmClock.create game: game, finish: finish, context: context, player: player_2
      end
      @expected_alarm_clock_ids = AlarmClock.all.map{|alarm_clock| alarm_clock.id}
    end

    it "checks the alarm for all games" do
      Timecop.freeze(Time.at(@time_now.in(15.seconds).to_i)) do
        notifier = AlarmClockNotifier.new
        AlarmClock.subscribe(notifier)

        AlarmChecker.run
        expect(notifier.result).to be_truthy
        expect(notifier.alarm_clock_ids).to eq @expected_alarm_clock_ids
      end
    end
  end
end
