class Result < ApplicationRecord
  belongs_to :game

  def result_set
    JSON.parse content
  end

  def result_set= content_hash
    self.content = content_hash.to_json
  end
end
