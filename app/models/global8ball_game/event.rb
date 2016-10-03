module Global8ballGame
  class Event
    def initialize arguments={}
      raise "No payload given to be initialized" if arguments.empty?
      raise "Payload given has to be a hash of objects" unless arguments.instance_of? Hash
    end
  end
end
