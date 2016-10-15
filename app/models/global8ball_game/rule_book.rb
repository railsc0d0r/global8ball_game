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

      def rules_for event=nil, search_tag=nil
        event = event.to_sym unless event.nil?
        search_tag = search_tag.to_sym unless search_tag.nil?
        results = nil

        raise "You have to give at least an eventname to parse the rules for. Maybe you wanted to use :all_rules instead?" if event.nil?
        raise "Eventname given can't be symbolized" unless event.class == Symbol
        raise "Searchtag given can't be symbolized" if search_tag.nil? && !search_tag.class == Symbol

        rules_for_event = @rules[event]

        if search_tag.nil?
          results = rules_for_event unless rules_for_event.nil? || rules_for_event.class != Array
        else
          results = rules_for_tag rules_for_event unless rules_for_event.nil? || rules_for_event.class != Array
        end

        results
      end

      protected

      # TODO: Implement this!!
      def rules_for_tag rules
        []
      end
    end
end
