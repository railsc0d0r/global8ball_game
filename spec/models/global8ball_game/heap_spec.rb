require 'rails_helper'

module Global8ballGame
  RSpec.describe Heap, type: :model do
    before do
      @event_heap = Heap.new

      @object_creator = ObjectCreator.new
      @bodies = @object_creator.create_bodies_for_collision_events
      @breakball = @bodies[:balls][:breakball]
      @eightball = @bodies[:balls][:eightball]
      @right_top_hole = @bodies[:holes][:right_top_hole]

      @ce = Event::Collision.new body_a: @breakball, body_b: @right_top_hole
    end

    it "takes an event and stores it." do
      @event_heap.push @ce

      expect(@event_heap.count).to be 1
    end

    it "returns the first event on next and removes it from heap." do
      @event_heap.push @ce

      expect(@event_heap.return_next).to be @ce
      expect(@event_heap.count).to be 0
    end

    it "returns true if it's empty." do
      expect(@event_heap.empty?).to be_truthy
      @event_heap.push @ce

      expect(@event_heap.empty?).to be_falsy
      @event_heap.return_next
      expect(@event_heap.empty?).to be_truthy
    end

    it "returns all elements it contains as an array" do
      ce_1 = Event::Collision.new body_a: @breakball, body_b: @right_top_hole
      ce_2 = Event::Collision.new body_a: @eightball, body_b: @right_top_hole

      @event_heap.push ce_1
      @event_heap.push ce_2

      expect(@event_heap.to_a).to eq [ce_1, ce_2]
    end

    it "can be cleared" do
      ce_1 = Event::Collision.new body_a: @breakball, body_b: @right_top_hole
      ce_2 = Event::Collision.new body_a: @eightball, body_b: @right_top_hole

      @event_heap.push ce_1
      @event_heap.push ce_2
      expect(@event_heap.empty?).to be_falsy

      @event_heap.clear

      expect(@event_heap.empty?).to be_truthy
    end
  end
end
