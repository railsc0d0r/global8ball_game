#
# Global8ballGame::BodyCreationConcern
#
# Lets model including this concern create bodies and shapes based on P2PhysicsWrapper
#
# provides a reader to a body ready to be added the world
#
module Global8ballGame
  module BodyCreationConcern
    extend ActiveSupport::Concern

    BORDER = 2 ** 2
    HOLE = 2 ** 3
    BALL = 2 ** 4
    LINE = 2 ** 5

    BORDER_COLLIDES_WITH = BALL
    HOLE_COLLIDES_WITH = BALL
    LINE_COLLIDES_WITH = BALL
    BALL_COLLIDES_WITH = BORDER | HOLE | BALL | LINE

    included do
      attr_reader :body
    end

    protected

    def create_body body_type, key, options, shape
      body = P2PhysicsWrapper::P2.Body.new options
      body.body_type = body_type
      body.key = key
      body.addShape shape
      body
    end

    def convex vertices
      P2PhysicsWrapper::P2.Convex.new({vertices: vertices})
    end

    def circle radius
      P2PhysicsWrapper::P2.Circle.new({ radius: radius })
    end

    def line length
      P2PhysicsWrapper::P2.Line.new({ length: length })
    end
  end
end
