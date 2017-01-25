module Global8ballGame
  module Configuration
    # A class to define general parameters of our game
    class Table < Base
      def initialize
        cue_mass = 0.7
        ball_mass = BallPosition.breakball_mass
        max_cue_speed = 2.7432 # m/s => See http://billiards.colostate.edu/threads/physics.html#properties, fast shot
        max_breakball_speed = cue_mass / ball_mass * max_cue_speed
        min_ball_speed = 0.000001

        @definition = {
          table: {
            damping: 0.12 + Random.new.rand(0.05...0.1),
            max_breakball_speed: max_breakball_speed,
            min_ball_speed: min_ball_speed,
            scaling_factor: 377.95,
            contact_materials: {
              ball_border: {
                restitution: 0.9,
                stiffness: 'INFINITY'
              },
              ball_ball: {
                restitution: 0.98,
                stiffness: 'INFINITY'
              }
            }
          }
        }
      end
    end
  end
end
