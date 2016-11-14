module Global8ballGame
  class ShotResult
    attr_reader :shot
    attr_accessor :foul, :events
    def initialize shot
      raise "Shot given isn't a valid Shot-object." unless shot.class == Shot
      @shot = shot
      @foul = false
      @events = []
    end

    def to_hash
      result = {
        shot_results: {
          shot: @shot.to_hash,
          foul: @foul,
          events: @events
        }
      }
      result.deep_stringify_keys
    end
  end
end
