module Global8ballGame
  class Heap
    def initialize
      @events = []
    end

    def push event
      @events << event
    end

    def return_next
      @events.shift
    end

    def count
      @events.count
    end

    def empty?
      @events.empty?
    end
  end
end
