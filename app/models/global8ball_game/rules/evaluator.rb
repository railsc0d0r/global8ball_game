module Global8ballGame
  module Rules
    class Evaluator
      attr_reader :stage
      def initialize stage_name=nil
        raise "No stage given to initialize Rules::Evaluator" if stage_name.nil?
        raise "Unknown stage given to initialize Rules::Evaluator" unless ['PlayForBegin', 'PlayForVictory'].include? stage_name

        @stage = stage_name

        @rule_books = []
        @rule_books << ForEveryStage.new
        @rule_books << ForPlayForBegin.new if stage_name == 'PlayForBegin'
        @rule_books << ForPlayForVictory.new if stage_name == 'PlayForVictory'
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
end
