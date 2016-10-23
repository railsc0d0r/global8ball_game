module Global8ballGame
  class RulesForEveryStage < RuleBook
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
            searchtags: [:breakball_falls_into_a_hole, :eightball_falls_into_a_hole, :ball_falls_into_a_hole],
            msg: :ball_falls_into_a_hole,
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
