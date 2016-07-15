module Global8ballGame
  class BallPosition < Config
    # scalingFactor = 377.95 =>
    @width = 2.54
    @halfWidth = @width / 2         # 480px
    @quarterWidth = @halfWidth / 2  # 240px
    @diameter = 0.0582              # 22px
    @radius = @diameter / 2         # 11px
    @xDiff = Math.sqrt(3 * @radius ** 2)
    @yDiff = @radius

    @positions = {
      'PlayForBegin': {},
      'PlayForVictory': {}
    }

    class << self
      def config state=''
        raise "No state given to get starting ball-positions for." if state.blank?
        raise "Invalid state given to get starting ball-positions for. Known states: #{@positions.keys.map{|k| "'" + k.to_s + "'"}.join(', ')}" unless @positions.keys.map{|k| k.to_s}.include? state

        @positions[state.to_sym]
      end

      def config_json state=''
        self.config(state).to_json
      end

    end
  end
end
