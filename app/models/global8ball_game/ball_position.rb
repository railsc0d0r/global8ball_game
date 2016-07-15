module Global8ballGame
  class BallPosition < Config
    @positions = {
      'PlayForBegin': {},
      'PlayForVictory': {}
    }

    class << self
      def config state=''
        raise "No state given to get starting ball-positions for." if state.blank?
        raise "Invalid state given to get starting ball-positions for. Known states: #{@positions.keys.map{|k| "'" + k.to_s + "'"}.join(', ')}" unless state == 'PlayForBegin' || state == 'PlayForVictory'

        @positions[state.to_sym]
      end

      def config_json state=''
        self.config(state).to_json
      end

    end
  end
end
