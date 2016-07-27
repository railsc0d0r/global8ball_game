module Global8ballGame
  class Border < Config
    def initialize
      # scalingFactor = 377.95 =>
      @width = 2.54
      @halfWidth = @width / 2         # 480px
      @quarterWidth = @halfWidth / 2  # 240px
      @cushionWidth=0.0582            # 22px
      @angleDiff36px=0.0953           # 36px
      @angleDiff32px=0.0847           # 32px
      @angleDiff30px=0.0794           # 30px
      @angleDiff10px=0.0265           # 10px

      @definition = {
        borders:
          { left:
            [
              {
                x: -( @halfWidth + @cushionWidth ),
                y: @quarterWidth - @angleDiff10px
              },
              {
                x: -( @halfWidth + @cushionWidth ),
                y: -( @quarterWidth - @angleDiff10px )
              },
              {
                x: -@halfWidth,
                y: -( @quarterWidth - @angleDiff36px )
              },
              {
                x: -@halfWidth,
                y: @quarterWidth - @angleDiff36px
              }
            ],
            leftBottom:
            [
              {
                x: -( @halfWidth - @angleDiff10px ),
                y: @quarterWidth + @cushionWidth
              },
              {
                x: -@cushionWidth,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: -@angleDiff30px,
                y: @quarterWidth
              },
              {
                x: -( @halfWidth - @angleDiff32px ),
                y: @quarterWidth
              }
            ],
            rightBottom:
            [
              {
                x: @cushionWidth,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: @halfWidth - @angleDiff10px,
                y: @quarterWidth + @cushionWidth
              },
              {
                x: @halfWidth - @angleDiff32px,
                y: @quarterWidth
              },
              {
                x: @angleDiff30px,
                y: @quarterWidth
              }
            ],
            right:
            [
              {
                x: @halfWidth + @cushionWidth,
                y: @quarterWidth - @angleDiff10px
              },
              {
                x: @halfWidth + @cushionWidth,
                y: -( @quarterWidth - @angleDiff10px )
              },
              {
                x: @halfWidth,
                y: -( @quarterWidth - @angleDiff36px )
              },
              {
                x: @halfWidth,
                y: @quarterWidth - @angleDiff36px
              }
            ],
            rightTop:
            [
              {
                x: @halfWidth - @angleDiff10px,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: @cushionWidth,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: @angleDiff30px,
                y: -@quarterWidth
              },
              {
                x: @halfWidth - @angleDiff32px,
                y: -@quarterWidth
              }
            ],
            leftTop:
            [
              {
                x: -@cushionWidth,
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: -( @halfWidth - @angleDiff10px ),
                y: -( @quarterWidth + @cushionWidth )
              },
              {
                x: -( @halfWidth - @angleDiff32px ),
                y: -@quarterWidth
              },
              {
                x: -@angleDiff30px,
                y: -@quarterWidth
              }
            ]
          }
      }
    end
  end
end
