module Global8ballGame
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
