#
# Model to create a world and interact w/ this world to return a new state
# and evaluate all events happening by given ruleset
#
module Global8ballGame
  class Table
    attr_reader :world, :config, :stage_name, :everything_stopped

    def initialize table_config
      @config = table_config

      world_options = {
        gravity: [0,0]
      }
      @world = P2PhysicsWrapper::P2.World.new world_options

      add_contact_materials @config['table']['contact_materials']

      initialize_borders @config['borders']
      initialize_holes @config['holes']

      @event_heap = Heap.new
    end

    def initialize_last_state state
      @current_state = GameState.new state
      @rules_evaluator = Rules::Evaluator.new @current_state.stage_name unless @current_state.stage_name == 'ShowResult'

      add_center_line if @current_state.stage_name == 'PlayForBegin'

      initialize_balls @current_state.balls
    end

    def shoot shot
      @shot_result = ShotResult.new shot

      fixed_time_step = 0.0078125
      velocity = [shot.velocity_x,-(shot.velocity_y)] # P2 uses inverted y-coordinates
      set_breakball_velocity shot.shooter, velocity
      @everything_stopped = false

      # sets up event-listeners
      @world.on('beginContact', Proc.new { |world| checkCollisions world.beginContactEvent })
      @world.on('postStep', Proc.new { postStep })

      until @everything_stopped do
        @world.step(fixed_time_step)
      end

      return
    end

    def current_state
      raise "Table isn't initialized yet." if @current_state.nil?

      bc = BallsCollector.new @world
      @current_state.balls = bc.balls_states

      unless @shot_result.nil?
        @current_state.shot_results = @shot_result.to_hash
      end
      @current_state.to_hash
    end

    private

    def initialize_borders borders_config
      body_type = "border"
      borders_config.keys.each do |key|
        border_config = borders_config[key]
        vertices = border_config.map do |vertice|
          [vertice['x'], -vertice['y']]  # P2 uses inverted y-coordinates
        end

        border = Border.new key, vertices, @border_material
        @world.addBody border.body
      end
    end

    def initialize_holes holes_config
      body_type = "hole"
      holes_config.keys.each do |key|
        hole_config = holes_config[key]
        radius = hole_config['radius']
        x = hole_config['x']
        y = -hole_config['y'] # P2 uses inverted y-coordinates
        position = [x, y]

        hole = Hole.new key, radius, position
        @world.addBody hole.body
      end
    end

    def initialize_balls balls
      body_type = "ball"
      damping = @config['table']['damping']

      balls.each do |ball|
        key = ball['id']
        owner = ball['owner']
        ball_type = ball['type']
        color = ball['color']
        mass = ball['mass']
        radius = ball['radius']
        x = ball['position']['x']
        y = -ball['position']['y'] # P2 uses inverted y-coordinates
        position = [x, y]

        ball = Ball.new key, owner, ball_type, color, damping, mass, radius, position, @ball_material
        @world.addBody ball.body
      end
    end

    def add_center_line
      @world.addBody CenterLine.new.body
    end

    def set_breakball_velocity user_id, velocity
      breakball = @world.bodies.select {|b| b.body_type == 'ball'}
                   .select {|b| b.ball_type == 'breakball' && b.owner == user_id}
                   .first
      breakball.velocity = velocity
    end

    def checkCollisions contact_event
      bodyA = contact_event.bodyA
      bodyB = contact_event.bodyB

      ce = Event::Collision.new body_a: bodyA, body_b: bodyB
      @event_heap.push ce
    end

    def postStep
      until @event_heap.empty? do
        event = @event_heap.return_next
        rules = @rules_evaluator.get_rules_for event

        handle_rules rules, event
      end
      check_velocity
    end

    def handle_rules rules, event
      rules.each do |rule|
        is_conditional = rule[:conditional]

        if is_conditional
          condition_met = self.send(rule[:condition], event)
          self.send(rule[:advice], event) if condition_met
        else
          self.send(rule[:advice], event)
        end
      end
    end

    def reinstate_breakball event
      @shot_result.foul = true

      result = {
        ball_id: event.get_ball.id,
        event: event.kind_of_event,
        advice: 'reinstate_breakball'
      }

      @shot_result.events.push result.deep_stringify_keys
    end

    def restart_round event
      puts "restart_round"
    end

    def remove_ball event
      ball = event.get_ball
      @world.removeBody ball

      result = {
        ball_id: ball.id,
        event: event.kind_of_event,
        advice: 'remove_ball'
      }

      @shot_result.events.push result.deep_stringify_keys
    end

    def round_lost event
      puts "round_lost"
      @shot_result.foul = true

      result = {
        ball_id: event.get_ball.id,
        event: event.kind_of_event,
        advice: 'round_lost'
      }

      @shot_result.events.push result.deep_stringify_keys
    end

    def round_won event
      puts "round_won"
    end

    # Only for PlayForVictory
    def change_breaker event
      puts "change_breaker"
    end

    # Only for PlayForVictory
    def breaker_is_eightball_owner event
      breaker = @current_state.current_players.first['user_id']
      eightball = event.get_ball
      eightball['owner'] == breaker
    end

    # Only for PlayForVictory
    def breaker_is_not_eightball_owner event
      !breaker_is_eightball_owner event
    end

    def check_velocity
      everything_stopped = true
      min_speed = 0.000001

      bc = BallsCollector.new @world
      bc.balls.each do |ball|
        everything_stopped = false if ball.velocity[0].abs > min_speed || ball.velocity[1].abs > min_speed
      end

      @everything_stopped = everything_stopped
    end

    def add_contact_materials contact_materials
      @ball_material = P2PhysicsWrapper::P2.Material.new
      @border_material = P2PhysicsWrapper::P2.Material.new

      restitution = parse_infinity contact_materials['ball_border']['restitution']
      stiffness = parse_infinity contact_materials['ball_border']['stiffness']

      ball_border_contact_material = P2PhysicsWrapper::P2.ContactMaterial.new @ball_material, @border_material, { restitution: restitution, stiffness: stiffness }
      @world.addContactMaterial ball_border_contact_material

      restitution = parse_infinity contact_materials['ball_ball']['restitution']
      stiffness = parse_infinity contact_materials['ball_ball']['stiffness']

      ball_ball_contact_material = P2PhysicsWrapper::P2.ContactMaterial.new @ball_material, @ball_material, { restitution: restitution, stiffness: stiffness }
      @world.addContactMaterial ball_ball_contact_material
    end

    def parse_infinity value
      value == 'INFINITY' ? Float::INFINITY : value
    end
  end
end
