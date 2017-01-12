module Global8ballGame
  class Game < Ohm::Model
    include ModelValidationConcern
    # include PhysicsConcern
    include Ohm::DataTypes
    include Ohm::Timestamps

    attribute :config, Type::Hash
  end
end
