require 'rails_helper'

module Global8ballGame
  module Configuration
    RSpec.describe Table, type: :model do
      before do
        @table_config = Table.new
        @config = @table_config.config[:table]
      end

      it "provides a config-snippet as a hash w/ a key 'table' and another hash as value" do
        expect(@config).to_not be_nil
        expect(@config).to be_an_instance_of(Hash)
      end

      it "provides the same config-snippet as a json-string" do
        expect(@table_config.config_json).to be_an_instance_of(String)
        expect(JSON.parse(@table_config.config_json).deep_symbolize_keys).to eq(@table_config.config)
      end

      it "provides the max-breakball-speed as computed from max-cue-speed, cue-mass and ball-mass" do
        expect(@config[:max_breakball_speed]).to eq 11.295529411764704
      end

      it "provides the factor to convert meters into px and vice versa as 377.95" do
        expect(@config[:scaling_factor]).to eq 377.95
      end

      it "provides a damping-factor between 0.12 and 0.22 to add a little randomness to each table" do
        expect(0.12...0.22).to cover(@config[:damping])
      end

      it "provides values for contact_materials" do
        expect(@config.key?(:contact_materials)).to be_truthy
        expect(@config[:contact_materials]).to be_a_kind_of Hash
      end
    end
  end
end
