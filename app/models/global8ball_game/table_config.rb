module Global8ballGame
  class TableConfig < Config
    def initialize
      cue_mass = 0.7
      ball_mass = BallPositionConfig.breakball_mass
      max_cue_speed = 5.4864 # m/s => See http://billiards.colostate.edu/threads/physics.html#properties, fast shot
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
