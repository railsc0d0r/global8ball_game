module Global8ballGame
  class Result < Ohm::Model
    include Ohm::Validations

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

    protected

    def validate
      raise "No content/result_set given for Result." unless assert_present(:content)
    end
  end
end
