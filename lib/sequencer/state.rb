module Sequencer 

  class State
    
    attr_accessor :pointer, :repeat

    def initialize
      @pointer = 0
      @repeat = 0
    end
    
    # Iterate to the next step
    # @param [Fixnum] length The total length of the sequence
    # @return [Boolean]
    def step(length)
      if @pointer < length - 1
        @pointer += 1
      else
        reset
      end
      true
    end
    
    # Iterate to the beginning of the sequence
    # @return [Boolean]
    def reset
      @pointer = 0
      @repeat += 1
      true
    end
            
  end
  
end
