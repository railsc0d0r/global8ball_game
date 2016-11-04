module Global8ballGame
  module Rules
    class Book
      def initialize
        @rules = {
          fictional_event: []
        }
      end

      def all_rules
        @rules
      end

      def rules_for event, search_tag
        raise "Eventname given is not a symbol" unless event.class == Symbol
        raise "Searchtag given is not a symbol" unless search_tag.class == Symbol

        rules_for_tag @rules[event], search_tag
      end

      protected

      def rules_for_tag rules, search_tag
        return [] if rules.nil?

        result = rules.select do |rule|
          rule[:searchtags].include? search_tag
        end.map do |rule|
          rule_to_return = rule.clone
          rule_to_return.delete(:searchtags)
          rule_to_return
        end
      end
    end
  end
end
