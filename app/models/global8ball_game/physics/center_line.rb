module Global8ballGame
  module Physics
    class CenterLine
      include BodyCreationConcern

      def initialize
        body_type = "line"
        key = "center"
        x = 0
        y = 0
        length = 2.54

        body_options = {
          mass:0,
          position: [x, y],
          angle: 0,
          velocity: [0, 0],
          angularVelocity: 0
        }

        shape = line length
        shape.collisionGroup = LINE
        shape.collisionMask = LINE_COLLIDES_WITH
        shape.collisionResponse = false

        @body = create_body body_type, key, body_options, shape
      end
    end
  end
end
