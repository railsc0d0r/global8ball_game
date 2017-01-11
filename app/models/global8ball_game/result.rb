module Global8ballGame
  class Result < Ohm::Model
    include ModelValidationConcern
    include Ohm::DataTypes
    include Ohm::Timestamps

    attribute :result_set, Type::Hash
    reference :game, :Game

    def game
      Game.find game_id
    end

    protected

    def validate
      raise "No content/result_set given for Result." unless assert_present(:content)
      raise "No game given for Result." unless assert_present(:game_id)
    end
  end
end
