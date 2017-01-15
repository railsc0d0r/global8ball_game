module Global8ballGame
  class Result < Ohm::Model
    include ModelValidationConcern
    include Ohm::DataTypes
    include Ohm::Timestamps

    attribute :result_set, Type::Hash
    reference :game, :Game

    def game
      Game[game_id]
    end

    protected

    def validate
      assert_present(:result_set)
      assert_present(:game_id)
    end
  end
end
