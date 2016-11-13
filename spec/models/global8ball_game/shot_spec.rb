require 'rails_helper'

module Global8ballGame
  RSpec.describe Shot, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players
      @config = @object_creator.create_table_config
      @config.deep_stringify_keys!
    end

    it "expects a shot-hash on initialize and provides its content as attributes." do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: @config['table']['max_breakball_speed'],
          y: 0
        }
      }

      expect {Shot.new}.to raise_error ArgumentError

      shot = Shot.new shot_hash
      expect(shot.shooter).to eq shot_hash[:user_id]
      expect(shot.velocity_x).to eq shot_hash[:velocity][:x]
      expect(shot.velocity_y).to eq shot_hash[:velocity][:y]
    end

    it "returns its attributes as a hash." do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: @config['table']['max_breakball_speed'],
          y: 0
        }
      }

      shot = Shot.new shot_hash

      expect(shot.to_hash).to eq shot_hash.deep_stringify_keys
    end

    it "validates the velocity-vector given to be less or equal max_breakball_speed" do
      shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: @config['table']['max_breakball_speed'] + 1,
          y: 0
        }
      }

      expect {Shot.new shot_hash}.to raise_error "Velocity given exceeds maximum breakball-speed."
    end
  end
end
