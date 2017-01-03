module Global8ballGame
  class StopWatch < Ohm::Model
    include Ohm::DataTypes

    attribute :start, Type::Time
    attribute :stop, Type::Time
    reference :game, :Game

    def game
      Game.find game_id
    end
  end
end
