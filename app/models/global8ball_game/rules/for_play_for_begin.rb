module Global8ballGame
  module Rules
    class ForPlayForBegin < Book
      def initialize
        @rules = {
          collision: [
            {
              searchtags: [
                :breakball_falls_into_a_hole,
                :breakball_crosses_center_line,
                :breakball_collides_with_side_border
              ],
              advice: :round_lost,
              foul: true,
              conditional: false
            }
          ],
          timeout_event: []
        }
      end
    end
  end
end
