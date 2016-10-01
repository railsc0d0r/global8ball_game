module Global8ballGame
  class Event
    def initialize payload={}
      raise "No payload given to be initialized" if payload.empty?
      raise "Payload given has to be a hash of objects" unless payload.instance_of? Hash
    end
  end
end
