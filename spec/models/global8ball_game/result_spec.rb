require 'rails_helper'

module Global8ballGame
  RSpec.describe Result, type: :model do
    before do
      @content = {
        a: 1,
        b: "123"
      }
    end

    it "provides an attribute called content to store json as string" do
      content = "123"
      Result.create content: "123"

      expect(Result.all.first.content).to eq content
    end

    it "provides a method to convert given hash to JSON and store it as string in content" do
      Result.create result_set: @content
      expect(Result.all.first.content).to eq @content.to_json
    end

    it "provides a method to convert stored content-string to hash and return it" do
      Result.create content: @content.to_json
      expect(Result.all.first.result_set).to eq @content.deep_stringify_keys
    end

    it "belongs to a Game" do
      object_creator = ObjectCreator.new
      game = Game.create!

      Result.create result_set: @content, game: game
      expect(Result.all.first.game).to eq game
    end
  end
end
