module Global8ballGame
  class Result < Ohm::Model
    include Ohm::Validations
    include Ohm::Timestamps

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
      raise "No game given for Result." unless assert_present(:game_id)
    end
  end
end
