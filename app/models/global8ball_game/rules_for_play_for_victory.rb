module Global8ballGame
  class RulesForPlayForVictory < RuleBook
    def initialize
      @rules = {
        collision_event: [
          {
            searchtags: [:eightball_falls_into_a_hole],
            msg: :eightball_falls_into_a_hole,
            advice: :round_lost,
            foul: true,
            conditional: true
          }
        ]
      }
    end
  end
end
