require 'rails_helper'

module Global8ballGame
  RSpec.describe Game, type: :model do
    before do
      object_creator = ObjectCreator.new
      @config = object_creator.create_table_config
      @player_1 = object_creator.players[:player_1]
      @player_2 = object_creator.players[:player_2]
      @game = Game.create player_1_id: @player_1.id, player_1_name: @player_1.name, player_2_id: @player_2.id, player_2_name: @player_2.name
    end

    it "provides timestamps on create and update" do
      expect(@game.created_at).to be_kind_of Time
      expect(@game.updated_at).to be_kind_of Time
    end

    it "includes Global8ballGame::PhysicsConcern" do
      expect(Game.include? Global8ballGame::PhysicsConcern).to be_truthy
    end

    it "provides config as attribute to store a hash" do
      expect(Game.all.first.config).to be_kind_of Hash
    end

    it "generates a new config before create" do
      result_config = Game.all.first.config
      damping = result_config['table'].delete('damping')
      @config[:table].delete(:damping)

      expect(0.12...0.22).to cover(damping)
      expect(result_config).to eq @config.deep_stringify_keys
    end

    it "has a collection of results" do
      result = Result.create result_set: {a: "test"}, game: @game

      expect(@game.results).to be_kind_of Ohm::Set
      expect(@game.results.first).to eq result
    end

    it "deletes all results belonging to it if deleted" do
      game_id = @game.id
      result = Result.create result_set: {a: "test"}, game: @game
      @game.delete

      expect(Result.find(game_id: game_id)).to be_empty
    end

    it "provides a method to store the last result in Redis" do
      state = State::Initial.new @game.player_1_id, @game.player_2_id
      @game.last_result = state.to_hash

      expect(Result.find(game_id: @game.id).to_a.last.result_set).to eq state.to_hash
    end

    it "provides a method to retrieve the last result for a game" do
      expect(@game.last_result).to be_nil

      state = State::Initial.new @game.player_1_id, @game.player_2_id
      @game.last_result = state.to_hash

      expect(@game.last_result).to eq state.to_hash
    end

    it "has a collection of AlarmClocks" do
      time_now = Time.now
      finish = Time.at(time_now.in(5.seconds).to_i)
      context = :shotclock
      alarm_clock = AlarmClock.create game: @game, finish: finish, context: context, player: @player_1

      expect(@game.alarm_clocks).to be_kind_of Ohm::Set
      expect(@game.alarm_clocks.first).to eq alarm_clock
    end

    it "deletes all AlarmClocks belonging to it if deleted" do
      game_id = @game.id
      time_now = Time.now
      finish = Time.at(time_now.in(5.seconds).to_i)
      context = :shotclock
      alarm_clock = AlarmClock.create game: @game, finish: finish, context: context, player: @player_1

      @game.delete

      expect(AlarmClock.find(game_id: game_id)).to be_empty
    end

    it "stores id of player 1" do
      expect(Game.all.first.player_1_id).to eq @player_1.id.to_s
    end

    it "validates presence of player_1_id" do
      expect {Game.create player_1_name: @player_1.name, player_2_id: @player_2.id, player_2_name: @player_2.name}.to raise_error "Global8ballGame::Game is not valid. Errors: player_1_id is not present."
    end

    it "stores name of player 1" do
      expect(Game.all.first.player_1_name).to eq @player_1.name
    end

    it "validates presence of player_1_name" do
      expect {Game.create player_1_id: @player_1.id, player_2_id: @player_2.id, player_2_name: @player_2.name}.to raise_error "Global8ballGame::Game is not valid. Errors: player_1_name is not present."
    end

    it "stores player 2 as id" do
      expect(Game.all.first.player_2_id).to eq @player_2.id.to_s
    end

    it "validates presence of player_2_id" do
      expect {Game.create player_1_id: @player_1.id, player_1_name: @player_1.name, player_2_name: @player_2.name}.to raise_error "Global8ballGame::Game is not valid. Errors: player_2_id is not present."
    end

    it "stores name of player 2" do
      expect(Game.all.first.player_2_name).to eq @player_2.name
    end

    it "validates presence of player_2_name" do
      expect {Game.create player_1_id: @player_1.id, player_1_name: @player_1.name, player_2_id: @player_2.id}.to raise_error "Global8ballGame::Game is not valid. Errors: player_2_name is not present."
    end

    it "generates an initial state and stores it as last_result" do
      state = State::Initial.new @game.player_1_id, @game.player_2_id
      @game.initialize_state

      expect(@game.last_result).to eq state.to_hash
    end
  end
end
