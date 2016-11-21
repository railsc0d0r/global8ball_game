require 'rails_helper'

module Global8ballGame
  module Configuration
    RSpec.describe BallPosition, type: :model do
      before do
        @ball_position_config = BallPosition
        @known_stages = ["PlayForBegin", "PlayForVictory", "ShowResult"]
      end

      it "raises an error if no stage is given as argument to get positions for" do
        expect {@ball_position_config.config}.to raise_error "No stage given to get starting ball-positions for."
      end

      it "raises an error if given stage is not defined" do
        state = "PlayForNothing"
        expect {@ball_position_config.config state}.to raise_error "Invalid stage given to get starting ball-positions for. Known stages: #{@known_stages.map{|k| "'" + k.to_s + "'"}.join(', ')}"
      end

      it "returns a hash w/ key :balls and an array of configurations for 2 balls for state 'PlayForBegin'" do
        balls = @ball_position_config.config('PlayForBegin')[:balls]

        expect(balls).to_not be_nil
        expect(balls).to be_an_instance_of Array
        expect(balls.count).to eq 2
      end

      it "returns a hash w/ key :balls and an array of configurations for 16 balls for state 'PlayForVictory'" do
        balls = @ball_position_config.config('PlayForVictory')[:balls]

        expect(balls).to_not be_nil
        expect(balls).to be_an_instance_of Array
        expect(balls.count).to eq 16
      end

      it "returns a hash w/ key :balls and an empty array of configurations for state 'ShowResult'" do
        balls = @ball_position_config.config('ShowResult')[:balls]

        expect(balls).to_not be_nil
        expect(balls).to be_an_instance_of Array
        expect(balls).to be_empty
      end

      it "provides configurations for balls as hash w/ defined properties" do
        properties = [:id, :type, :color, :owner, :radius, :mass, :position]
        position_properties = [:x, :y]
        ball_types = ['breakball', 'playball', '8ball']
        colors = ['white', 'black', 'red', 'gold']

        @known_stages.each do |state|
          balls = @ball_position_config.config(state)[:balls]
          balls.each do |ball_config|
            expect(ball_config.keys).to match_array properties

            expect(ball_config[:type]).to_not be_nil
            expect(ball_config[:type]).to be_a_kind_of String
            expect(ball_types).to include ball_config[:type]

            expect(ball_config[:color]).to_not be_nil
            expect(ball_config[:color]).to be_a_kind_of String
            expect(colors).to include ball_config[:color]

            expect(ball_config[:radius]).to_not be_nil
            expect(ball_config[:radius]).to be_a_kind_of Numeric

            expect(ball_config[:mass]).to_not be_nil
            expect(ball_config[:mass]).to be_a_kind_of Numeric

            expect(ball_config[:position].keys).to match_array position_properties
            position_properties.each do |property|
              expect(ball_config[:position][property]).to be_a_kind_of Numeric
            end
          end
        end
      end

      it "provides positions for all balls within the bounds of a 9ft table" do
        @known_stages.each do |state|
          balls = @ball_position_config.config(state)[:balls]
          balls.each do |ball_config|
            position = ball_config[:position]
            expect(-1.27...1.27).to cover position[:x]
            expect(-0.635...0.635).to cover position[:y]
          end
        end
      end

      it "defines ball-mass and exposes it" do
        expect(@ball_position_config.mass).to eq 0.17
      end

      it "defines halfWidth and exposes it" do
        expect(@ball_position_config.halfWidth).to eq 1.27
      end

      it "defines quarterWidth and exposes it" do
        expect(@ball_position_config.quarterWidth).to eq 0.635
      end

      it "defines radius and exposes it" do
        expect(@ball_position_config.radius).to eq 0.0291
      end
    end
  end
end
