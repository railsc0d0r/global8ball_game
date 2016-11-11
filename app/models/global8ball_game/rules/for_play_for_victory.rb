module Global8ballGame
  module Rules
    class ForPlayForVictory < Book
      def initialize
        @rules = {
          collision: [
            {
              searchtags: [:breakball_falls_into_a_hole],
              msg: :breakball_falls_into_a_hole,
              advice: :reinstate_breakball,
              foul: true,
              conditional: false
            },
            {
              searchtags: [:breakball_falls_into_a_hole],
              msg: :breakball_falls_into_a_hole,
              advice: :change_breaker,
              foul: true,
              conditional: false
            },
            {
              searchtags: [:eightball_falls_into_a_hole],
              msg: :round_lost,
              advice: :round_lost,
              foul: true,
              conditional: true,
              condition: :breaker_is_not_eightball_owner
            },
            {
              searchtags: [:eightball_falls_into_a_hole],
              msg: :round_won,
              advice: :round_won,
              foul: false,
              conditional: true,
              condition: :breaker_is_eightball_owner
            }
          ]
        }
      end
    end
  end
end
