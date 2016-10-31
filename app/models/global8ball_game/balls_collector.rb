module Global8ballGame
  class BallsCollector
    attr_reader :balls

    def initialize world
      raise "Object given isn't a P2PhysicsWrapper::P2.World." unless world.class == V8::Object && world['constructor'].name == 'World'
    end
  end
end
