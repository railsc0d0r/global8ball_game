require 'rails_helper'

module Global8ballGame
  module Configuration
    RSpec.describe BorderConfig, type: :model do
      before do
        @border_config = Global8ballGame::Configuration::BorderConfig.new
        @config = @border_config.config[:borders]
      end

      it "provides a config-snippet as a hash w/ a key 'borders' and another hash as value" do
        expect(@config).to_not be_nil
        expect(@config).to be_an_instance_of Hash
      end

      it "provides the same config-snippet as a json-string" do
        expect(@border_config.config_json).to be_an_instance_of String
        expect(JSON.parse(@border_config.config_json).deep_symbolize_keys).to eq @border_config.config
      end

      it "provides 6 arrays of 4 hashes to describe the borders" do
        expect(@config.keys.count).to eq 6
        @config.keys.each do |border|
          expect(@config[border]).to be_an_instance_of Array
          expect(@config[border].count).to eq 4
          @config[border].each do |point|
            expect(point).to be_an_instance_of Hash
          end
        end
      end

      it "describes each border as an array of points w/ numeric values for x- and y-position" do
        @config.keys.each do |border|
          @config[border].each do |point|
            point_keys = [:x, :y]
            expect(point.keys).to match_array point_keys
            point_keys.each do |point_key|
              expect(point[point_key]).to be_a_kind_of Numeric
            end
          end
        end
      end
    end
  end
end
