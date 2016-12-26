module Global8ballGame
  class Result < Ohm::Model
    attribute :content

    def result_set
      JSON.parse content
    end

    def result_set= content_hash
      self.content = content_hash.to_json
      self.save
    end
  end
end
