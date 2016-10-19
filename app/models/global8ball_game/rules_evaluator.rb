module Global8ballGame
  class RulesEvaluator
    attr_reader :stage
    def initialize stage_name=nil
      raise "No stage given to initialize RulesEvaluator" if stage_name.nil?
      raise "Unknown stage given to initialize RulesEvaluator" unless ['PlayForBegin', 'PlayForVictory'].include? stage_name

      @stage = stage_name

      @rule_books = []
      @rule_books << RulesForEveryStage.new
      @rule_books << RulesForPlayForBegin.new if stage_name == 'PlayForBegin'
      @rule_books << RulesForPlayForVictory.new if stage_name == 'PlayForVictory'
    end

    def get_rules_for event
      event_name = event.class.to_s.demodulize.underscore.to_sym
      search_tag = event.kind_of_event

      rules = []

      @rule_books.each do |book|
        rules += book.rules_for event_name, search_tag
      end

      rules
    end
  end
end
