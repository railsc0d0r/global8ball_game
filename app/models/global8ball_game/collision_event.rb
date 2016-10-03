module Global8ballGame
  class CollisionEvent < Event
    attr_reader :body_a, :body_b
    def initialize arguments={}
      super
      [:body_a, :body_b].each do |key|
        body_name = key.to_s.split(/ |\_/).map(&:capitalize).join(" ")
        raise "#{body_name} is not a p2-body." unless is_p2_body arguments[key]
      end

      @body_a = arguments[:body_a]
      @body_b = arguments[:body_b]
    end

    private

    def is_p2_body obj
      P2PhysicsWrapper::P2.Body.prototype.isPrototypeOf obj
    end
  end
end
