module Global8ballGame
  class BallPosition < Config
    # scalingFactor = 377.95 =>
    @width = 2.54
    @halfWidth = @width / 2          # 480px
    @quarterWidth = @halfWidth / 2   # 240px
    @eighthWidth = @quarterWidth / 2 # 120px
    @diameter = 0.0582              # 22px
    @radius = @diameter / 2         # 11px
    @xDiff = Math.sqrt(3 * @radius ** 2)
    @yDiff = @radius

    @positions = {
      'PlayForBegin': {
                        balls: [
                          {
                            id: 1,
                            type: 'breakball',
                            color: 'white',
                            owner: nil,
                            position: {
                              x: -@quarterWidth,
                              y: -@eighthWidth
                            }
                          },
                          {
                            id: 2,
                            type: 'breakball',
                            color: 'white',
                            owner: nil,
                            position: {
                              x: -@quarterWidth,
                              y: @eighthWidth
                            }
                          }
                        ]
                      },
      'PlayForVictory': {
                          balls: [
                            {
                              id: 1,
                              type: 'breakball',
                              color: 'white',
                              owner: nil,
                              position: {
                                x: -@quarterWidth,
                                y: 0
                              }
                            }
                          ]
                        }
    }

    counter = 1

    0.upto(4) do |x|
      0.upto(x) do |y|
        unless counter == 5
          counter += 1
          position = {
            id: counter,
            type: 'playball',
            color: 'white',
            owner: nil,
            position: {
              x: @quarterWidth + (x-2) * @xDiff,
              y: 0 + (1) * @yDiff # TODO: compute values dynamically
            }
          }
        end
      end
    end

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
