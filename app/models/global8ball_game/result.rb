module Global8ballGame
  class Result < Ohm::Model
    attribute :content

    def result_set= content_hash
      self.content = content_hash.to_json
    end
  end
end
