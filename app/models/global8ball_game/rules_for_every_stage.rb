module Global8ballGame
  class RulesForEveryStage < RuleBook
    def initialize
      @rules = {
        collision_event: []
      }
    end
  end
end
