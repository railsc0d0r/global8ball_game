module Global8ballGame
  class CollisionEvent < Event
    attr_reader :body_a, :body_b
    def initialize arguments={}
      super
      not_p2_bodies = []
      [:body_a, :body_b].each do |key|
        not_p2_bodies << key.to_s.split(/ |\_/).join(" ") unless is_p2_body arguments[key]
      end
      raise "Following bodies are not p2-bodies: #{not_p2_bodies.join(', ')}." unless not_p2_bodies.empty?

      @body_a = arguments[:body_a]
      @body_b = arguments[:body_b]
    end

    def contains_breakball
      (@body_a.body_type == "ball" && @body_a.ball_type == "breakball") ||
      (@body_b.body_type == "ball" && @body_b.ball_type == "breakball")
    end

    def contains_8ball
      (@body_a.body_type == "ball" && @body_a.ball_type == "8ball") ||
      (@body_b.body_type == "ball" && @body_b.ball_type == "8ball")
    end

    def contains_two_balls
      @body_a.body_type == "ball" && @body_b.body_type == "ball"
    end

    def contains_center_line
      (@body_a.body_type == "line" && @body_a.key == "center") ||
      (@body_b.body_type == "line" && @body_b.key == "center")
    end

    private

    def is_p2_body obj
      P2PhysicsWrapper::P2.Body.prototype.isPrototypeOf obj
    end
  end
end
