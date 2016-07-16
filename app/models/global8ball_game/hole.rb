module Global8ballGame
  class Hole < Config
    # scalingFactor = 377.95 =>
    @width = 2.54
    @halfWidth = @width / 2         # 480px
    @quarterWidth = @halfWidth / 2  # 240px

    @xWidth=@halfWidth
    @yWidth=@quarterWidth
    @radius=0.0582
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