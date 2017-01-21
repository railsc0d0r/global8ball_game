require 'rails_helper'

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
        alarm_clock_1 = AlarmClock.create game: game, finish: finish, context: context, player: player_1
        alarm_clock_2 = AlarmClock.create game: game, finish: finish, context: context, player: player_2
      end
    end

    it "checks the alarm for all games" do
      Timecop.freeze(Time.at(@time_now.in(15.seconds).to_i)) do
        result = false

        AlarmClock.all.each do |clock|
          clock.on(:sound_the_alarm) do
            result = true
          end
        end

        AlarmChecker.run
        expect(result).to be_truthy
      end
    end
  end
end
