class Result < ApplicationRecord
  belongs_to :game

  def result_set
    JSON.parse content
  end
end
