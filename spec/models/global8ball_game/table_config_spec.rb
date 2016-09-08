require 'rails_helper'

module Global8ballGame
  RSpec.describe TableConfig, type: :model do
    before do
      @table_config = Global8ballGame::TableConfig.new
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

    it "provides the cue-mass as 0.7kg" do
      expect(@config[:cue_mass]).to eq 0.7
    end

    it "provides the factor to convert meters into px and vice versa as 377.95" do
      expect(@config[:scaling_factor]).to eq 377.95
    end

    it "provides a damping-factor between 0.12 and 0.22 to add a little randomness to each table" do
      expect(0.12...0.22).to cover(@config[:damping])
    end

    it "provides a value for border_bounce" do
      expect(@config.key?(:border_bounce)).to be_truthy
      expect(@config[:border_bounce]).to be_a_kind_of Numeric
    end

    it "provides a value for cue_hardness" do
      expect(@config.key?(:cue_hardness)).to be_truthy
      expect(@config[:cue_hardness]).to be_a_kind_of Numeric
    end
  end
end
