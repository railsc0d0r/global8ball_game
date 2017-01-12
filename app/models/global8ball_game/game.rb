module Global8ballGame
  class Game < Ohm::Model
    include ModelValidationConcern
    # include PhysicsConcern
    include Ohm::DataTypes
    include Ohm::Timestamps

    attribute :config, Type::Hash

    def config_json
      config.to_json
    end

    protected

    def validate
      assert_present(:config)
    end
  end
end
