module Global8ballGame
  module Config
    class BallPositionConfig
      # scalingFactor = 377.95 =>
      @width = 2.54
      @halfWidth = @width / 2          # 480px
      @quarterWidth = @halfWidth / 2   # 240px
      @eighthWidth = @quarterWidth / 2 # 120px
      @diameter = 0.0582               # 22px
      @radius = @diameter / 2          # 11px
      @xDiff = Math.sqrt(3 * @radius ** 2)
      @yDiff = @diameter
      @mass = 0.17 # kg

      @positions = {
        'PlayForBegin': {
          balls: [
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
          ]
        },
        'PlayForVictory': {
          balls: [
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
          ]
        },
        'ShowResult': {
          balls: []
        }
      }

      counter = 1
      color = 'red'

      0.upto(4) do |x|
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
          @positions['PlayForVictory'.to_sym][:balls] << position
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

        def breakball_mass
          @mass
        end
      end
    end
  end
end
