module Global8ballGame
  module Rules
    class ForPlayForBegin < Book
      def initialize
        @rules = {
          collision: [
            {
              searchtags: [:breakball_falls_into_a_hole],
              advice: :restart_round,
              foul: true,
              conditional: false
            },
            {
              searchtags: [:breakball_crosses_center_line],
              advice: :restart_round,
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
