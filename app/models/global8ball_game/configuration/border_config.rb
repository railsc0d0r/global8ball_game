module Global8ballGame
  module Configuration
    class BorderConfig < Config
      def initialize
        # scalingFactor = 377.95 =>
        @width = 2.54
        @halfWidth = @width / 2         # 480px
        @quarterWidth = @halfWidth / 2  # 240px
        @cushionWidth=0.0582            # 22px
        @radius=0.047625347        # 18px

        @angleDiff31px=0.082021431      # 31px
        @angleDiff28px=0.074083874      # 28px
        @angleDiff25px=0.066146316      # 25px
        @angleDiff4px=0.010583411       # 4px

        @definition = {
          borders:
          { left:
            [
              {
                x: -@halfWidth,
                y: @quarterWidth - @angleDiff28px
              },
              {
                x: -@halfWidth,
                y: -( @quarterWidth - @angleDiff28px )
              },
              {
                x: -( @halfWidth + @cushionWidth ),
                y: -( @quarterWidth - @angleDiff4px )
              },
              {
                x: -( @halfWidth + @cushionWidth ),
                y: @quarterWidth - @angleDiff4px
              }
            ],
            leftBottom:
            [
              {
                x: -( @halfWidth - @angleDiff4px ),
                y: @quarterWidth + @cushionWidth
              },
              {
                x: -@radius,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: -@angleDiff25px,
                y: @quarterWidth
              },
              {
                x: -( @halfWidth - @angleDiff31px ),
                y: @quarterWidth
              }
            ],
            rightBottom:
            [
              {
                x: @radius,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: @halfWidth - @angleDiff4px,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: @halfWidth - @angleDiff31px,
                y: @quarterWidth
              },
              {
                x: @angleDiff25px,
                y: @quarterWidth
              }
            ],
            right:
            [
              {
                x: @halfWidth + @cushionWidth,
                y: @quarterWidth - @angleDiff4px
              },
              {
                x: @halfWidth + @cushionWidth,
                y: -( @quarterWidth - @angleDiff4px )
              },
              {
                x: @halfWidth,
                y: -( @quarterWidth - @angleDiff28px )
              },
              {
                x: @halfWidth,
                y: @quarterWidth - @angleDiff28px
              }
            ],
            rightTop:
            [
              {
                x: @halfWidth - @angleDiff4px,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: @radius,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: @angleDiff25px,
                y: -@quarterWidth
              },
              {
                x: @halfWidth - @angleDiff31px,
                y: -@quarterWidth
              }
            ],
            leftTop:
            [
              {
                x: -@radius,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: -( @halfWidth - @angleDiff4px ),
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: -( @halfWidth - @angleDiff31px ),
                y: -@quarterWidth
              },
              {
                x: -@angleDiff25px,
                y: -@quarterWidth
              }
            ]
          }
        }
      end
    end
  end
end
