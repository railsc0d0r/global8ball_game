require 'rails_helper'

module Global8ballGame
  RSpec.describe Result, type: :model do
    it "provides an attribute called content to store json as string" do
      result = Result.create content: "123"
    end
  end
end
