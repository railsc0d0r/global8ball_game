module Global8ballGame
  class Shot
    attr_reader :shooter, :velocity_x, :velocity_y
    def initialize shot
      @shooter = shot[:user_id]
      @velocity_x = shot[:velocity][:x]
      @velocity_y = shot[:velocity][:y]

      raise "Velocity given exceeds maximum breakball-speed." unless velocity_valid
    end

    def to_hash
      result = {
        user_id: shooter,
        velocity: {
          x: velocity_x,
          y: velocity_y
        }
      }

      result.deep_stringify_keys
    end

    private

    def velocity_valid
      max_breakball_speed = Configuration::Table.new.config[:table][:max_breakball_speed]
      velocity_amount = Math.sqrt(@velocity_x.abs2 + @velocity_y.abs2).abs

      velocity_amount <= max_breakball_speed
    end
  end
end
