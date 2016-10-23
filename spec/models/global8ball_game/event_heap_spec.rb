require 'rails_helper'

module Global8ballGame
  RSpec.describe EventHeap, type: :model do
    before do
      @event_heap = EventHeap.new

      @object_creator = ObjectCreator.new
      @breakball, @playball, @playball2, @eightball, @center_line, @right_border, @right_top_hole = @object_creator.create_bodies_for_collision_events
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
  end
end
