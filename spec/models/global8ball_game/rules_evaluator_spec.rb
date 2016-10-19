require 'rails_helper'

module Global8ballGame
  RSpec.describe RulesEvaluator, type: :model do
    before do
      @object_creator = ObjectCreator.new
      @breakball, @playball, @playball2, @eightball, @center_line, @right_border, @right_top_hole = @object_creator.create_bodies_for_collision_events
    end

    it "can be instanciated w/ a given stage_name" do
      expect {RulesEvaluator.new()}.to raise_error "No stage given to initialize RulesEvaluator"
      stage_name = 'PlayForBegin'
      expect(RulesEvaluator.new(stage_name).instance_of? RulesEvaluator).to be_truthy
    end

    it "only knows 'PlayForBegin' and 'PlayForVictory' as stages" do
      stage_names = ['PlayForBegin', 'PlayForVictory']

      stage_names.each do |stage_name|
        expect(RulesEvaluator.new(stage_name).instance_of? RulesEvaluator).to be_truthy
      end

      stage_name = 'ShowResult'
      expect {RulesEvaluator.new(stage_name)}.to raise_error "Unknown stage given to initialize RulesEvaluator"
    end

    it "stores the given stage_name and provides an attr_reader for it" do
      stage_name = 'PlayForBegin'
      expect(RulesEvaluator.new(stage_name).stage).to be stage_name
    end
  end
end
