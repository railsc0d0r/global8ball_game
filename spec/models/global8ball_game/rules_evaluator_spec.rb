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

    it "takes an event and evaluates all rule_books concerning its stage." do
      # breakball falls into a hole in PlayForBegin
      stage_name = 'PlayForBegin'
      rules_evaluator =  RulesEvaluator.new(stage_name)

      ce = Event::Collision.new body_a: @breakball, body_b: @right_top_hole

      expected_result = [
        {
          msg: :breakball_falls_into_a_hole,
          advice: :reinstate_breakball,
          foul: true,
          conditional: false
        },
        {
          msg: :ball_falls_into_a_hole,
          advice: :remove_ball,
          foul: false,
          conditional: false
        }
      ]

      expect(rules_evaluator.get_rules_for ce).to eq expected_result

      # eightball falls into a hole in PlayForVictory
      stage_name = 'PlayForVictory'
      rules_evaluator =  RulesEvaluator.new(stage_name)

      ce = Event::Collision.new body_a: @eightball, body_b: @right_top_hole

      expected_result = [
        {
          msg: :ball_falls_into_a_hole,
          advice: :remove_ball,
          foul: false,
          conditional: false
        },
        {
          msg: :round_lost,
          advice: :round_lost,
          foul: true,
          conditional: true,
          condition: :breaker_is_not_eightball_owner
        },
        {
          msg: :round_won,
          advice: :round_won,
          foul: false,
          conditional: true,
          condition: :breaker_is_eightball_owner
        }
      ]

      expect(rules_evaluator.get_rules_for ce).to eq expected_result
    end
  end
end
