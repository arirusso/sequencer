module Sequencer 

  class Pointer
    
    def initialize
      @pointer = 0
    end
    
    # Iterate to the next step
    # @return [Fixnum]
    def step(options = {})
      @pointer = self.next
    end

    def next
      @pointer + 1
    end
    
    # Iterate to the beginning of the sequence
    # @return [Boolean]
    def reset(range)
      @pointer = get_start(:range => range)
      true
    end

    def to_i
      @pointer
    end

    private

    # Gets the start position
    # @return [Fixnum]
    def get_start(options = {})
      !options[:range].nil? ? options[:range].begin : 0
    end
            
  end
  
end
