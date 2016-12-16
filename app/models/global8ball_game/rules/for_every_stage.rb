module Global8ballGame
  module Rules
    class ForEveryStage < Book
      def initialize
        @rules = {
          collision: [
            {
              searchtags: [:breakball_falls_into_a_hole, :eightball_falls_into_a_hole, :ball_falls_into_a_hole],
              advice: :remove_ball,
              foul: false,
              conditional: false
            }
          ],
          timeout_event: []
        }
      end
    end
  end
end
