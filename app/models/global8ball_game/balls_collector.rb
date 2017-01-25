module Global8ballGame
  # A class to be used to collect all balls_states from the world
  class BallsCollector
    attr_reader :balls

    def initialize world
      raise "Object given isn't a P2PhysicsWrapper::P2.World." unless world.class == V8::Object && world['constructor'].name == 'World'
      @balls_states = []

      @balls = world.bodies.select{|body| body.body_type == 'ball'}
    end

    def balls_states
      result = []
      @balls.each do |ball|
        result << ball_state(ball)
      end

      result
    end

    private

    def ball_state ball
      position = ball.position.to_a
      state = {
        id: ball.key,
        type: ball.ball_type,
        color: ball.color,
        owner: ball['owner'],
        radius: ball.shapes.first.radius,
        mass: ball.mass,
        position: {
          x: position[0],
          y: -position[1]
        }
      }

      state.deep_stringify_keys
    end
  end
end
