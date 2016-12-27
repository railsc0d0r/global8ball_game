require 'rails_helper'

module Global8ballGame
  RSpec.describe Result, type: :model do
    before do
      @content = {
        a: 1,
        b: "123"
      }

      object_creator = ObjectCreator.new
      @game = Game.create!
    end

    it "provides an attribute called content to store json as string" do
      content = "123"
      Result.create content: "123", game: @game

      expect(Result.all.first.content).to eq content
    end

    it "provides a method to convert given hash to JSON and store it as string in content" do
      Result.create result_set: @content, game: @game
      expect(Result.all.first.content).to eq @content.to_json
    end

    it "provides a method to convert stored content-string to hash and return it" do
      Result.create content: @content.to_json, game: @game
      expect(Result.all.first.result_set).to eq @content.deep_stringify_keys
    end

    it "belongs to a Game" do
      Result.create result_set: @content, game: @game
      expect(Result.all.first.game).to eq @game
    end

    it "validates presence of content" do
      expect {Result.create game: @game}.to raise_error "No content/result_set given for Result."
    end

    it "validates presence of a game" do
      expect {Result.create result_set: @content}.to raise_error "No game given for Result."
    end
  end
end
