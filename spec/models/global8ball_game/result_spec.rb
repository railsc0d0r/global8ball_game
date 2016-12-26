require 'rails_helper'

module Global8ballGame
  RSpec.describe Result, type: :model do
    it "provides an attribute called content to store json as string" do
      content = "123"
      result = Result.create content: "123"

      expect(result.content).to eq content
    end

    it "provides a method to convert given hash to JSON and store it as string in content" do
      content = {
        a: 1,
        b: "123"
      }

      result = Result.create
      result.result_set = content

      expect(result.content).to eq content.to_json
    end
  end
end
