module Global8ballGame
  class Hole < Config
    @definition = {
      holes:
        {
          leftTop:
            {
              x: -1.3282,
              y: -0.6932,
              radius: 0.0582
            },
          leftBottom:
            {
              x: -1.3282,
              y: 0.6932,
              radius: 0.0582
            },
          centerBottom:
            {
              x: 0,
              y: 0.6932,
              radius: 0.0582
            },
          rightBottom:
            {
              x: 1.3282,
              y: 0.6932,
              radius: 0.0582
            },
          rightTop:
            {
              x: 1.3282,
              y: -0.6932,
              radius: 0.0582
            },
          centerTop:
            {
              x: 0,
              y: -0.6932,
              radius: 0.0582
            }
        }
    }
  end
end
