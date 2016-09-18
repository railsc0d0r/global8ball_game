#
# Model to create a world and interact w/ this world to return a new state and evaluate certain rules by given ruleset
#
module Global8ballGame
  class Table
    attr_reader :world, :config, :everything_stopped

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
      body_type = "ball"
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

        body = create_body body_type, key, body_options, shape
        body.damping = damping
        body.owner = owner
        body.ball_type = ball['type']

        @world.addBody body
      end
    end

    def shoot shot
      fixed_time_step = 0.01
      velocity = [shot['velocity']['x'],shot['velocity']['y']]
      user_id = shot['user_id']

      set_breakball_velocity user_id, velocity
      @everything_stopped = false

      # check collisions and rules
      @world.on('postStep', Proc.new { postStep })

      until @everything_stopped do
        @world.step(fixed_time_step)
      end
      # return result_set
    end

    private

    def initialize_borders borders_config
      body_type = "border"
      borders_config.keys.each do |key|
        border_config = borders_config[key]
        body_options = {
          mass: 0,
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

        body = create_body body_type, key, body_options, shape
        @world.addBody body
      end
    end

    def initialize_holes holes_config
      body_type = "hole"
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

        body = create_body body_type, key, body_options, shape
        @world.addBody body
      end
    end

    def set_breakball_velocity user_id, velocity
      breakball = @world.bodies.select {|b| b.body_type == 'ball'}
                   .select {|b| b.ball_type == 'breakball' && b.owner == user_id}
                   .first
      breakball.velocity = velocity
    end

    def postStep
      puts "After step:"
      puts "World-time: #{@world.time}"
      show_ball_specs
      check_velocity
    end

    def show_ball_specs
      @world.bodies.select {|b| b.body_type == 'ball'}.each do |ball|
        puts "ball #{ball.key} -> vx: #{ball.velocity[0]} vy: #{ball.velocity[1]} x: #{ball.position[0]} y: #{ball.position[1]}"
      end
      puts "---------------------------------------------------------------------------------------------------"
    end

    def check_velocity
      everything_stopped = true
      min_speed = 0.00001
      @world.bodies.select {|b| b.body_type == 'ball'}.each do |ball|
        everything_stopped = false if ball.velocity[0].abs > min_speed || ball.velocity[1].abs > min_speed
      end

      @everything_stopped = everything_stopped
    end

    def create_body body_type, key, options, shape
      body = P2PhysicsWrapper::P2.Body.new options
      body.body_type = body_type
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
