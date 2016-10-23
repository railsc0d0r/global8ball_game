#
# Model to create a world and interact w/ this world to return a new state
# and evaluate all events happening by given ruleset
#
module Global8ballGame
  class Table
    attr_reader :world, :config, :everything_stopped

    def initialize table_config
      @config = table_config

      world_options = {
        gravity: [0,0]
      }
      @world = P2PhysicsWrapper::P2.World.new world_options

      add_contact_materials

      initialize_borders @config['borders']
      initialize_holes @config['holes']

      @event_heap = Event::Heap.new
    end

    def initialize_last_state state
      stage_name = state['current_stage']['stage_name']
      @rules_evaluator = RulesEvaluator.new stage_name unless stage_name == 'ShowResult'

      add_center_line if stage_name == 'PlayForBegin'

      body_type = "ball"
      damping = @config['table']['damping']

      state['balls'].each do |ball|
        key = ball['id']
        owner = ball['owner']
        ball_type = ball['type']
        mass = ball['mass']
        radius = ball['radius']
        x = ball['position']['x']
        y = -ball['position']['y'] # P2 uses inverted y-coordinates
        position = [x, y]

        ball = Ball.new key, owner, ball_type, damping, mass, radius, position, @ball_material
        @world.addBody ball.body
      end
    end

    def shoot shot
      fixed_time_step = 0.01
      velocity = [shot['velocity']['x'],shot['velocity']['y']]
      user_id = shot['user_id']

      set_breakball_velocity user_id, velocity
      @everything_stopped = false

      # sets up event-listeners
      @world.on('beginContact', Proc.new { |world| checkCollisions world.beginContactEvent })
      @world.on('postStep', Proc.new { postStep })

      until @everything_stopped do
        @world.step(fixed_time_step)
      end

      puts "---------------------------------------------------"
      puts "Finished stepping. World-time: #{@world.time}"
      puts "---------------------------------------------------"
      # return result_set
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

    def check_velocity
      everything_stopped = true
      min_speed = 0.000001
      @world.bodies.select {|b| b.body_type == 'ball'}.each do |ball|
        everything_stopped = false if ball.velocity[0].abs > min_speed || ball.velocity[1].abs > min_speed
      end

      @everything_stopped = everything_stopped
    end

    def add_contact_materials
      @ball_material = P2PhysicsWrapper::P2.Material.new
      @border_material = P2PhysicsWrapper::P2.Material.new

      ball_border_contact_material = P2PhysicsWrapper::P2.ContactMaterial.new @ball_material, @border_material, { restitution: 0.9, stiffness: Float::INFINITY }
      @world.addContactMaterial ball_border_contact_material

      ball_ball_contact_material = P2PhysicsWrapper::P2.ContactMaterial.new @ball_material, @ball_material, { restitution: 0.98, stiffness: Float::INFINITY }
      @world.addContactMaterial ball_ball_contact_material
    end
  end
end
