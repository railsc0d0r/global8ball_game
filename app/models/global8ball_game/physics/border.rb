module Global8ballGame
  module Physics
    class Border
      include BodyCreationConcern

      def initialize key, vertices, material
        body_type = "border"

        body_options = {
          mass: 0,
          position: [0, 0],
          angle: 0,
          velocity: [0, 0],
          angularVelocity: 0
        }

        shape = convex vertices
        shape.collisionGroup = BORDER
        shape.collisionMask = BORDER_COLLIDES_WITH
        shape.material = material

        @body = create_body body_type, key, body_options, shape
      end
    end
  end
end
