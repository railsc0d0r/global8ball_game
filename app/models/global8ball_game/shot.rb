module Global8ballGame
  class Shot
    attr_reader :shooter, :velocity_x, :velocity_y
    def initialize shot
      @shooter = shot['user_id']
      raise "No user_id given in shot-arguments." if @shooter.nil?

      velocity = shot['velocity']
      raise "No velocity-vector given in shot-arguments." if velocity.nil?
      raise "Velocity-vector given in shot-arguments has to be a hash containing x- and y-values as numeric values." unless velocity_vector_valid velocity

      @velocity_x = velocity['x']
      @velocity_y = velocity['y']

      raise "Velocity given exceeds maximum breakball-speed." unless velocity_doesnt_exceed_max_breakball_speed
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

    def velocity_doesnt_exceed_max_breakball_speed
      max_breakball_speed = Configuration::Table.new.config[:table][:max_breakball_speed]
      velocity_amount = Math.sqrt(@velocity_x.abs2 + @velocity_y.abs2).abs

      velocity_amount <= max_breakball_speed
    end

    def velocity_vector_valid vector
      vector.class == Hash &&
      vector.keys == ['x', 'y'] &&
      vector['x'].to_f.class == Float &&
      !vector['x'].nil? &&
      vector['y'].to_f.class == Float &&
      !vector['y'].nil?
    end
  end
end
