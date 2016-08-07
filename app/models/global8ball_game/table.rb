#
# Model to create a world and interact w/ this world to return a new state and evaluate certain rules by given ruleset
#
module Global8ballGame
  class Table
    attr_reader :world, :config

    BORDER = 2 ** 2
    HOLE = 2 ** 3
    BALL = 2 ** 4
    LINE = 2 ** 5

    BORDER_COLLIDES_WITH = BALL
    HOLE_COLLIDES_WITH = BALL
    LINE_COLLIDES_WITH = BALL
    BALL_COLLIDES_WITH = BORDER | HOLE | BALL | LINE

    def initialize table_config
      @config = table_config

      world_options = {
        gravity: [0,0]
      }
      @world = P2PhysicsWrapper::P2.World.new world_options

      initialize_borders @config['borders']
      initialize_holes @config['holes']
    end

    def initialize_last_state state
      damping = @config['table']['damping']

      state['balls'].each do |ball|
        key = ball['id']
        owner = ball['owner']
        mass = ball['mass']
        radius = ball['radius']
        x = ball['position']['x']
        y = ball['position']['y']

        body_options = {
          mass: mass,
          position: [x, y],
          angle: 0,
          velocity: [0, 0],
          angularVelocity: 0
        }

        shape = circle radius
        shape.collisionGroup = BALL
        shape.collisionMask = BALL_COLLIDES_WITH

        body = create_body key, body_options, shape
        body.damping = damping
        body.owner = owner

        @world.addBody body
      end
    end

    def shoot shot
      {}
    end

    private

    def initialize_borders borders_config
      borders_config.keys.each do |key|
        border_config = borders_config[key]
        body_options = {
          mass:0,
          position: [0, 0],
          angle: 0,
          velocity: [0, 0],
          angularVelocity: 0
        }

        vertices = border_config.map do |vertice|
            [vertice['x'], -vertice['y']]
        end
        shape = convex vertices
        shape.collisionGroup = BORDER
        shape.collisionMask = BORDER_COLLIDES_WITH

        body = create_body key, body_options, shape
        @world.addBody body
      end
    end

    def initialize_holes holes_config
      holes_config.keys.each do |key|
        hole_config = holes_config[key]

        body_options = {
          mass:0,
          position: [hole_config['x'], -hole_config['y']],
          angle: 0,
          velocity: [0, 0],
          angularVelocity: 0
        }

        shape = circle hole_config['radius']
        shape.collisionGroup = HOLE
        shape.collisionMask = HOLE_COLLIDES_WITH

        body = create_body key, body_options, shape
        @world.addBody body
      end
    end

    def create_body key, options, shape
      body = P2PhysicsWrapper::P2.Body.new options
      body.key = key
      body.addShape shape
      body
    end

    def convex vertices
      P2PhysicsWrapper::P2.Convex.new({vertices: vertices})
    end

    def circle radius
      P2PhysicsWrapper::P2.Circle.new({ radius: radius })
    end

  end
end
