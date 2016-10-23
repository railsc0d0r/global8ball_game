module Global8ballGame
  class RulesForPlayForBegin < RuleBook
    def initialize
      @rules = {
        collision: [
          {
            searchtags: [:breakball_crosses_center_line],
            msg: :breakball_crosses_center_line,
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
