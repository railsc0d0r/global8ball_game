module Global8ballGame
  class Ball
    include BodyCreationConcern

    def initialize key, owner, ball_type, color, damping, mass, radius, position, material
      body_type = "ball"
      body_options = {
        mass: mass,
        position: position,
        angle: 0,
        velocity: [0, 0],
        angularVelocity: 0
      }

      shape = circle radius
      shape.collisionGroup = BALL
      shape.collisionMask = BALL_COLLIDES_WITH
      shape.material = material

      @body = create_body body_type, key, body_options, shape
      @body.damping = damping
      @body.ccdSpeedThreshold = 1
      @body.ccdIterations = 2
      @body.owner = owner
      @body.ball_type = ball_type
      @body.color = color
    end
  end
end
