module Global8ballGame
  class Result < Ohm::Model
    attribute :content
    reference :game, :Game

    def result_set
      JSON.parse content
    end

    def result_set= content_hash
      self.content = content_hash.to_json
    end

    def game
      Game.find game_id
    end
  end
end
