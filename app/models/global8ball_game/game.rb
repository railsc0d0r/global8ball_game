module Global8ballGame
  class Game < Ohm::Model
    include ModelValidationConcern
    include PhysicsConcern
    include Ohm::DataTypes
    include Ohm::Timestamps
    include Ohm::Callbacks

    attribute :config, Type::Hash

    def before_delete
      Result.find(game_id: self.id).map &:delete
    end

    def results
      Result.find(game_id: self.id)
    end

    def config_json
      config.to_json
    end

    protected

    def validate
      assert_present(:config)
    end
  end
end
