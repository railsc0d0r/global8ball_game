module Global8ballGame
  class ShotResult
    attr_reader :shot, :events
    attr_accessor :foul
    def initialize shot = nil
      validate_shot shot

      @shot = shot
      @foul = false
      @events = Heap.new
    end

    def shot= shot
      validate_shot shot
      @shot = shot
    end

    def to_hash
      result = {
        shot: @shot.nil? ? {} : @shot.to_hash,
        foul: @foul,
        events: @events.to_a.uniq
      }
      result.deep_stringify_keys
    end

    private

    def validate_shot shot
      raise "Shot given isn't a valid Shot-object." unless shot.nil? || shot.class == Shot
    end
  end
end
