module Global8ballGame
  module Configuration
    class Table < Base
      def initialize
        cue_mass = 0.7
        ball_mass = BallPosition.breakball_mass
        max_cue_speed = 2.7432 # m/s => See http://billiards.colostate.edu/threads/physics.html#properties, fast shot
        max_breakball_speed = cue_mass / ball_mass * max_cue_speed

        @definition = {
          table: {
            border_bounce: 0,
            damping: 0.12 + Random.new.rand(0.05...0.1),
            max_breakball_speed: max_breakball_speed,
            scaling_factor: 377.95
          }
        }
      end
    end
  end
end
