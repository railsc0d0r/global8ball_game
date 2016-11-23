module Global8ballGame
  class ShotResult
    attr_reader :shot, :events
    attr_accessor :foul
    def initialize shot
      raise "Shot given isn't a valid Shot-object." unless shot.class == Shot
      @shot = shot
      @foul = false
      @events = Heap.new
    end

    def to_hash
      result = {
        shot: @shot.to_hash,
        foul: @foul,
        events: @events.to_a
      }
      result.deep_stringify_keys
    end
  end
end
