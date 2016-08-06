module Global8ballGame
  class Table < Config
    def initialize
      @definition = {
        table: {
          border_bounce: 0,
          damping: 0.2 + Random.new.rand(0.05...0.1),
          cue_hardness: 0,
          cue_mass: 0.7, # kg
          scaling_factor: 377.95
        }
      }
    end
  end
end
