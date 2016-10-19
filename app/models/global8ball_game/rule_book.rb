module Global8ballGame
  class RuleBook
      def initialize
        @rules = {
          fictional_event: []
        }
      end

      def all_rules
        @rules
      end

      def rules_for event, search_tag
        event = event.to_sym
        search_tag = search_tag.to_sym

        raise "Eventname given can't be symbolized" unless event.class == Symbol
        raise "Searchtag given can't be symbolized" if search_tag.nil? && !search_tag.class == Symbol

        rules_for_tag @rules[event], search_tag
      end

      protected

      def rules_for_tag rules, search_tag
        result = rules.select do |rule|
          rule[:searchtags].include? search_tag
        end.map do |rule|
          rule.delete(:searchtags)
          rule
        end
      end
    end
end
