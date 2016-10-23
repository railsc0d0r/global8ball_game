require 'rails_helper'

module Global8ballGame
  module Configuration
    RSpec.describe Hole, type: :model do
      before do
        @hole_config = Hole.new
        @config = @hole_config.config[:holes]
      end

      it "provides a config-snippet as a hash w/ a key 'holes' and another hash of hashes as value" do
        expect(@config).to_not be_nil
        expect(@config).to be_an_instance_of Hash
      end

      it "provides the same config-snippet as a json-string" do
        expect(@hole_config.config_json).to be_an_instance_of String
        expect(JSON.parse(@hole_config.config_json).deep_symbolize_keys).to eq @hole_config.config
      end

      it "provides 6 hashes to describe the holes" do
        expect(@config.keys.count).to eq 6
        @config.keys.each do |hole|
          expect(@config[hole]).to be_an_instance_of Hash
        end
      end

      it "describes each hole w/ numeric values for x- and y-position and the radius" do
        @config.keys.each do |hole|
          hole_keys = [:x, :y, :radius]
          expect(@config[hole].keys).to match_array hole_keys
          hole_keys.each do |hole_key|
            expect(@config[hole][hole_key]).to be_a_kind_of Numeric
          end
        end
      end
    end
  end
end
