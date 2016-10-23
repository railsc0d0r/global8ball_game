module Global8ballGame
  class Hole
    include BodyCreationConcern

    def initialize key, radius, position
      body_type = "hole"
      body_options = {
        mass:0,
        position: position,
        angle: 0,
        velocity: [0, 0],
        angularVelocity: 0
      }

      shape = circle radius
      shape.collisionGroup = HOLE
      shape.collisionMask = HOLE_COLLIDES_WITH

      @body = create_body body_type, key, body_options, shape
    end
  end
end
