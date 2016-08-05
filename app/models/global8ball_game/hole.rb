module Global8ballGame
  class Hole < Config
    def initialize
      # scalingFactor = 377.95 =>
      @width = 2.54
      @halfWidth = @width / 2         # 480px
      @quarterWidth = @halfWidth / 2  # 240px

      @xWidth=@halfWidth
      @yWidth=@quarterWidth

      @real_radius=0.0582             # 22px
      @ball_radius=0.0291             # 11px
      @radius = @real_radius - @ball_radius

      @cushionWidth=0.0582
      @cushionWidthHalf=0.0291

      @definition = {
        holes:
          {
            leftTop:
              {
                x: -( @xWidth + @cushionWidthHalf ),
                y: -( @yWidth + @cushionWidthHalf ),
                radius: @radius
              },
            leftBottom:
              {
                x: -( @xWidth + @cushionWidthHalf ),
                y: @yWidth + @cushionWidthHalf,
                radius: @radius
              },
            centerBottom:
              {
                x: 0,
                y: @yWidth + @cushionWidth,
                radius: @radius
              },
            rightBottom:
              {
                x: @xWidth + @cushionWidthHalf,
                y: @yWidth + @cushionWidthHalf,
                radius: @radius
              },
            rightTop:
              {
                x: @xWidth + @cushionWidthHalf,
                y: -( @yWidth + @cushionWidthHalf ),
                radius: @radius
              },
            centerTop:
              {
                x: 0,
                y: -( @yWidth + @cushionWidth ),
                radius: @radius
              }
          }
      }
    end
  end
end
