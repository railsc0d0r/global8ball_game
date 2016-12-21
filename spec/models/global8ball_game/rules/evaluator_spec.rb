require 'rails_helper'

module Global8ballGame
  module Rules
    RSpec.describe Evaluator, type: :model do
      before do
        @object_creator = ObjectCreator.new
        @bodies = @object_creator.create_bodies_for_collision_events
      end

      it "can be instanciated w/ a given stage_name" do
        expect {Evaluator.new()}.to raise_error "No stage given to initialize Rules::Evaluator"
        stage_name = 'PlayForBegin'
        expect(Evaluator.new(stage_name).instance_of? Evaluator).to be_truthy
      end

      it "only knows 'PlayForBegin' and 'PlayForVictory' as stages" do
        stage_names = ['PlayForBegin', 'PlayForVictory']

        stage_names.each do |stage_name|
          expect(Evaluator.new(stage_name).instance_of? Evaluator).to be_truthy
        end

        stage_name = 'ShowResult'
        expect {Evaluator.new(stage_name)}.to raise_error "Unknown stage given to initialize Rules::Evaluator"
      end

      it "stores the given stage_name and provides an attr_reader for it" do
        stage_name = 'PlayForBegin'
        expect(Evaluator.new(stage_name).stage).to be stage_name
      end

      it "takes an event and evaluates all rule_books concerning its stage." do
        breakball = @bodies[:balls][:breakball]
        eightball = @bodies[:balls][:eightball]
        right_top_hole = @bodies[:holes][:right_top_hole]

        # breakball falls into a hole in PlayForBegin
        stage_name = 'PlayForBegin'
        rules_evaluator =  Evaluator.new(stage_name)

        ce = Event::Collision.new body_a: breakball, body_b: right_top_hole

        expected_result = [
          {
            advice: :remove_ball,
            foul: false,
            conditional: false
          },
          {
            advice: :restart_round,
            foul: true,
            conditional: false
          }
        ]

        expect(rules_evaluator.get_rules_for ce).to eq expected_result

        # eightball falls into a hole in PlayForVictory
        stage_name = 'PlayForVictory'
        rules_evaluator =  Evaluator.new(stage_name)

        ce = Event::Collision.new body_a: eightball, body_b: right_top_hole

        expected_result = [
          {
            advice: :remove_ball,
            foul: false,
            conditional: false
          },
          {
            advice: :round_lost,
            foul: true,
            conditional: true,
            condition: :breaker_is_not_eightball_owner
          },
          {
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
end
