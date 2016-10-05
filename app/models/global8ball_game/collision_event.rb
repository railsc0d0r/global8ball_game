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
      (@body_a.body_type == "ball" && @body_a.ball_type == "8ball") ^
      (@body_b.body_type == "ball" && @body_b.ball_type == "8ball")
    end

    def contains_two_balls
      @body_a.body_type == "ball" && @body_b.body_type == "ball"
    end

    def contains_one_ball
      (@body_a.body_type == "ball") ^ (@body_b.body_type == "ball")
    end

    def contains_center_line
      (@body_a.body_type == "line" && @body_a.key == "center") ^
      (@body_b.body_type == "line" && @body_b.key == "center")
    end

    def contains_right_border
      (@body_a.body_type == "border" && @body_a.key == "right") ^
      (@body_b.body_type == "border" && @body_b.key == "right")
    end

    def contains_hole
      (@body_a.body_type == "hole") ^ (@body_b.body_type == "hole")
    end

    def ball_falls_into_a_hole
      contains_one_ball && contains_hole
    end

    def breakball_falls_into_a_hole
      ball_falls_into_a_hole && contains_breakball
    end

    def eightball_falls_into_a_hole
      ball_falls_into_a_hole && contains_8ball
    end

    def breakball_crosses_center_line
      contains_center_line && contains_breakball
    end

    private

    def is_p2_body obj
      P2PhysicsWrapper::P2.Body.prototype.isPrototypeOf obj
    end
  end
end
