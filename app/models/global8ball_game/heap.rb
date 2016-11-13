module Global8ballGame
  class Heap
    def initialize
      @elements = []
    end

    def push event
      @elements << event
    end

    def return_next
      @elements.shift
    end

    def count
      @elements.count
    end

    def empty?
      @elements.empty?
    end

    def clear
      @elements = []
    end

    def to_a
      @elements
    end
  end
end
