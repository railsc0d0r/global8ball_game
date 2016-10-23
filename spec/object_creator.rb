#
# This class holds methods to create objects for specs.
# It's more like a dump to remove clutter from spec_helper.rb
#
class ObjectCreator

  attr_reader :players

  def initialize
    @players = create_players
  end

  def create_table_config
    config = {}

    config.merge!(Global8ballGame::Configuration::TableConfig.new.config)
    config.merge!(Global8ballGame::Configuration::BorderConfig.new.config)
    config.merge!(Global8ballGame::Configuration::HoleConfig.new.config)
    config.merge!(players_config)

    config
  end

  def players_config
    {
      player_1: {
        user_id: @players[:player_1].id,
        name: @players[:player_1].name
      },
      player_2: {
        user_id: @players[:player_2].id,
        name: @players[:player_2].name
      }
    }
  end

  def initial_state player_1, player_2, stage_name="PlayForBegin", breaker=nil
    state = {
      current_stage: {
        stage_name: stage_name,
        round: 1
      }
    }

    state.merge!(Global8ballGame::Configuration::BallPositionConfig.config stage_name)

    current_players = {
      current_players: []
    }

    current_results = {
      current_results: []
    }

    if stage_name == 'PlayForBegin'
      state[:balls][0][:owner] = player_1.id
      state[:balls][1][:owner] = player_2.id
      current_players[:current_players] << { user_id: player_1.id}
      current_players[:current_players] << { user_id: player_2.id}
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

  def create_body body_type, key, options, shape = nil
    body = P2PhysicsWrapper::P2.Body.new options
    body.body_type = body_type
    body.key = key
    body.addShape shape unless shape.nil?
    body
  end

  def create_bodies_for_collision_events
    body_type = "ball"
    body_options = {
      mass: 0.7,
      position: [0, 0],
      angle: 0,
      velocity: [0, 0],
      angularVelocity: 0
    }

    key = 1
    breakball = create_body body_type, key, body_options
    breakball.ball_type = "breakball"

    key = 2
    playball = create_body body_type, key, body_options
    playball.ball_type = "playball"

    key = 3
    playball2 = create_body body_type, key, body_options
    playball.ball_type = "playball"

    key = 4
    eightball = create_body body_type, key, body_options
    eightball.ball_type = "8ball"

    key = "center"
    body_type = "line"
    center_line = create_body body_type, key, body_options

    key = "right"
    body_type = "border"
    right_border = create_body body_type, key, body_options

    key = "rightTop"
    body_type = "hole"
    right_top_hole = create_body body_type, key, body_options

    return breakball, playball, playball2, eightball, center_line, right_border, right_top_hole
  end

  private

  def create_players
    {
      player_1: FactoryGirl.create(:player),
      player_2: FactoryGirl.create(:player)
    }
  end

end
