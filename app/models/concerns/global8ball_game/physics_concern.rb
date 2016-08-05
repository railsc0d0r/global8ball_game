#
# Global8ballGame::PhysicsConcern
#
# Lets model including this concern instanciate a physics-world by given config and last state
# and interact w/ this world to return a new state end evaluate certain rules by given ruleset
#
# Models including this concern have to provide config and last_result as hashes representing the table_config and the last state
#
module Global8ballGame
  module PhysicsConcern
    extend ActiveSupport::Concern

    included do
      attr_reader :world

      BORDER = 2 ** 2
      HOLE = 2 ** 3
      BALL = 2 ** 4
      LINE = 2 ** 5

      BORDER_COLLIDES_WITH = BALL
      HOLE_COLLIDES_WITH = BALL
      LINE_COLLIDES_WITH = BALL
      BALL_COLLIDES_WITH = BORDER | HOLE | BALL | LINE
    end

    def eval_shot shot
      initialize_table
      initialize_last_state
    end

    protected

    def new_table_config
      config = {}

      config.merge!(Global8ballGame::Table.new.config)
      config.merge!(Global8ballGame::Border.new.config)
      config.merge!(Global8ballGame::Hole.new.config)

      config
    end

    def initial_state player_1, player_2, stage_name="PlayForBegin", breaker=nil
      state = {
          current_stage: {
              stage_name: stage_name,
              round: 1
            }
        }

      state.merge!(Global8ballGame::BallPosition.config stage_name)

      current_players = {
        current_players: []
      }

      current_results = {
        current_results: []
      }

      if stage_name == 'PlayForBegin'
        state[:balls][0][:owner] = player_1
        state[:balls][1][:owner] = player_2
        current_players[:current_players] << { user_id: player_1}
        current_players[:current_players] << { user_id: player_2}
      end

      if stage_name == 'PlayForVictory'
        state[:balls][0][:owner] = breaker
        current_players[:current_players] << { user_id: breaker}
        current_results[:current_results] << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }
      end

      state.merge!(current_players)

      if stage_name == 'ShowResult'
        current_results[:current_results] << {
          stage_name: 'PlayForBegin',
          winner: breaker
        }

        1.upto 3 do |round|
          current_results[:current_results] << {
            stage_name: 'PlayForVictory',
            round: round,
            winner: breaker
          }
        end
      end

      state.merge!(current_results)

      state
    end

    private

    def initialize_last_state
      damping = self.config['table']['damping']
      state = self.last_result

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
        body.applyDamping damping
        body.owner = owner
        @world.addBody body
      end
    end

    def initialize_table
      table_config = self.config

      world_options = {
        gravity: [0,0]
      }
      @world = P2PhysicsWrapper::P2.World.new world_options

      initialize_borders table_config['borders']
      initialize_holes table_config['holes']
    end

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
