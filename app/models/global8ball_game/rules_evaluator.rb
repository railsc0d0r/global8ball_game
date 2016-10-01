module Global8ballGame
  class RulesEvaluator
    attr_reader :stage
    def initialize stage_name=nil
      raise "No stage given to initialize RulesEvaluator" if stage_name.nil?
      raise "Unknown stage given to initialize RulesEvaluator" unless ['PlayForBegin', 'PlayForVictory'].include? stage_name

      @stage = stage_name
    end


  end
end
