module Global8ballGame
  class StopWatch < Ohm::Model

    reference :game, :Game

    def game
      Game.find game_id
    end
  end
end
