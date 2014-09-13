module Sequencer 

  class State
    
    attr_accessor :pointer, :repeat

    def initialize
      @pointer = 0
      @repeat = 0
    end
    
    def step(length)
      if @pointer < length - 1
        @pointer += 1
      else
        reset
      end
      true
    end
    
    # Return to the beginning of the sequence
    def reset
      @pointer = 0
      @repeat += 1
    end
            
  end
  
end
