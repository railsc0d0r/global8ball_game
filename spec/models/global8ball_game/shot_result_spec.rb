require 'rails_helper'

module Global8ballGame
  RSpec.describe ShotResult, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @players = @object_creator.players

      @shot_hash = {
        user_id: @players[:player_1].id,
        velocity: {
          x: 5.579606637080942,
          y: -0.8747776565806149
        }
      }
      @shot_hash.deep_stringify_keys!
      @shot = Shot.new @shot_hash

      @shot_result = ShotResult.new @shot
    end

    it "initializes ShotResult with an empty hash as shot if no shot is given" do
      shot_result = ShotResult.new
      expected_shot = {}
      actual_shot_results_hash = shot_result.to_hash

      expect(actual_shot_results_hash['shot']).to eql expected_shot
    end

    it "expects shot to be a Shot" do
      shot = Object.new
      expect {ShotResult.new shot}.to raise_error "Shot given isn't a valid Shot-object."
    end

    it "stores the shot and provides an attribute-reader to it." do
      expect(@shot_result.shot).to eq @shot
    end

    it "lets shot be overwritten" do
      shot_result = ShotResult.new
      shot_result.shot = @shot
      actual_shot_results_hash = shot_result.to_hash

      expect(actual_shot_results_hash['shot']).to eql @shot_hash
    end

    it "expects shot to be a Shot when storing the shot" do
      shot = Object.new
      shot_result = ShotResult.new

      expect {shot_result.shot = shot}.to raise_error "Shot given isn't a valid Shot-object."
    end

    it "initializes attribute foul w/ false and provides reader/writer to it." do
      expect(@shot_result.foul).to be_falsy
      @shot_result.foul = true
      expect(@shot_result.foul).to be_truthy
    end

    it "initializes events as an empty array and provides reader/writer to it." do
      expect(@shot_result.events).to be_kind_of Heap
      expect(@shot_result.events.empty?).to be_truthy
    end

    it "returns itself as a hash as specified." do
      events = []

      event = {
        ball_id: 1,
        event: 'ball falls into hole',
        advice: 'remove_ball'
      }
      event.deep_stringify_keys!
      events << event
      @shot_result.events.push event

      event = {
        ball_id: 2,
        event: 'breakball falls into hole',
        advice: 'reinstate_breakball'
      }

      event.deep_stringify_keys!
      events << event
      @shot_result.events.push event

      foul = true

      @shot_result.foul = foul

      result = {
        shot: @shot_hash,
        foul: foul,
        events: events
      }

      result.deep_stringify_keys!

      expect(@shot_result.to_hash).to eq result
    end
  end
end
