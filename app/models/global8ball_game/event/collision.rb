module Global8ballGame
  module Event
    class Collision < Base
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

      def contains_left_border
        (@body_a.body_type == "border" && @body_a.key == "left") ^
        (@body_b.body_type == "border" && @body_b.key == "left")
      end

      def contains_side_border
        (@body_a.body_type == "border" && ['leftTop', 'rightTop', 'leftBottom', 'rightBottom'].include?(@body_a.key)) ^
        (@body_b.body_type == "border" && ['leftTop', 'rightTop', 'leftBottom', 'rightBottom'].include?(@body_b.key))
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

      def breakball_collides_with_eightball
        contains_breakball && contains_8ball
      end

      def breakball_collides_with_right_border
        contains_breakball && contains_right_border
      end

      def breakball_collides_with_left_border
        contains_breakball && contains_left_border
      end

      def breakball_collides_with_side_border
        contains_breakball && contains_side_border
      end

      def get_ball
        raise "Don't know which ball to return." if contains_two_balls
        (@body_a.body_type == "ball") ? @body_a : nil || (@body_b.body_type == "ball") ? @body_b : nil
      end

      def kind_of_event
        case
        when breakball_falls_into_a_hole
          :breakball_falls_into_a_hole
        when eightball_falls_into_a_hole
          :eightball_falls_into_a_hole
        when ball_falls_into_a_hole
          :ball_falls_into_a_hole
        when breakball_crosses_center_line
          :breakball_crosses_center_line
        when breakball_collides_with_eightball
          :breakball_collides_with_eightball
        when breakball_collides_with_right_border
          :breakball_collides_with_right_border
        when breakball_collides_with_left_border
          :breakball_collides_with_left_border
        when breakball_collides_with_side_border
          :breakball_collides_with_side_border
        else
          :standard_collision
        end
      end

      private

      def is_p2_body obj
        P2PhysicsWrapper::P2.Body.prototype.isPrototypeOf obj
      end
    end
  end
end
