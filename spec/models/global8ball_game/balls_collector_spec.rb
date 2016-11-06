require 'rails_helper'

module Global8ballGame
  RSpec.describe BallsCollector, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players
      @config = @object_creator.create_table_config
      @config.deep_stringify_keys!
      @table = Global8ballGame::Table.new @config

      @state = @object_creator.initial_state @players[:player_1], @players[:player_2], "PlayForBegin"
      @state.deep_stringify_keys!
      @table.initialize_last_state @state
    end

    it "takes a world-object to initialize" do
      expect {BallsCollector.new}.to raise_error ArgumentError
      expect {BallsCollector.new Object.new}.to raise_error "Object given isn't a P2PhysicsWrapper::P2.World."
    end

    it "returns the balls from the world as an array" do
      bc = BallsCollector.new @table.world
      expect(bc.balls).to eq @table.world.bodies.select {|b| b.body_type == 'ball'}
    end

    it "returns an array of ball-hashes to be used in result_set" do
      bc = BallsCollector.new @table.world
      expect(bc.balls_states).to eq @state['balls']
    end
  end
end
