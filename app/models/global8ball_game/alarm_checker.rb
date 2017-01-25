module Global8ballGame
  # Class to check all running alarm_clocks
  # Triggers :sound_the_alarm if a clock is finished thus alerting subscribed listeners
  class AlarmChecker
    class << self
      def run
        Game.all.each do |game|
          game.alarm_clocks.each do |clock|
            clock.check!
          end
        end
      end
    end
  end
end
