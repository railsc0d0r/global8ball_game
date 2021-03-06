module Global8ballGame
  module Configuration
    # A static class to provide config-parameters for ball-positions depending
    # on a stage given
    class BallPosition
      # scalingFactor = 377.95 =>
      @width = 2.54
      @halfWidth = @width / 2          # 480px
      @quarterWidth = @halfWidth / 2   # 240px
      @eighthWidth = @quarterWidth / 2 # 120px
      @diameter = 0.0582               # 22px
      @radius = @diameter / 2          # 11px
      @xDiff = Math.sqrt(3) * @radius + 0.001
      @yDiff = @diameter + 0.001
      @mass = 0.17 # kg

      @positions = {
        'PlayForBegin': [
            {
              id: 1,
              type: 'breakball',
              color: 'white',
              owner: nil,
              radius: @radius,
              mass: @mass,
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
              radius: @radius,
              mass: @mass,
              position: {
                x: -@quarterWidth,
                y: @eighthWidth
              }
            }
        ],
        'PlayForVictory': [
            {
              id: 1,
              type: 'breakball',
              color: 'white',
              owner: nil,
              radius: @radius,
              mass: @mass,
              position: {
                x: -@quarterWidth,
                y: 0
              }
            }
        ],
        'ShowResult': []
      }

      counter = 1
      color = 'red'

      0.upto(4) do |x|
        color = x.even? ? 'red' : 'gold' unless x == 4 # We do this to mix the balls properly in PlayForVictory
        0.upto(x) do |y|
          counter += 1
          unless counter == 6
            position = {
              id: counter,
              type: 'playball',
              color: color,
              owner: nil,
              radius: @radius,
              mass: @mass,
              position: {
                x: @quarterWidth + (x-2) * @xDiff,
                y: -(x * @radius) + y * @yDiff
              }
            }
            color = color == 'red' ? 'gold' : 'red'
          else
            position = {
              id: counter,
              type: '8ball',
              color: 'black',
              owner: nil,
              radius: @radius,
              mass: @mass,
              position: {
                x: @quarterWidth + (x-2) * @xDiff,
                y: -(x * @radius) + y * @yDiff
              }
            }
          end
          @positions['PlayForVictory'.to_sym] << position
        end
      end

      class << self
        attr_reader :halfWidth, :quarterWidth, :mass, :radius

        def config stage=''
          raise "No stage given to get starting ball-positions for." if stage.blank?
          raise "Invalid stage given to get starting ball-positions for. Known stages: #{@positions.keys.map{|k| "'" + k.to_s + "'"}.join(', ')}" unless @positions.keys.map{|k| k.to_s}.include? stage

          @positions[stage.to_sym].map do |ball_position|
            ball_position.deep_stringify_keys
          end
        end

        def config_json stage=''
          self.config(stage).to_json
        end

        def breakball_mass
          @mass
        end

        def radius
          @radius
        end
      end
    end
  end
end
