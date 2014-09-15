module Sequencer 

  # Callbacks that when evaluate to true, will trigger the corresponding sequencer event
  class EventTrigger
          
    # Set the reset trigger.  When true, the sequence will go back to step 0
    # @param [Proc] block
    # @return [Proc]
    def reset(&block)
      @reset = block  
    end

    # Set the rest trigger. When true, no messages will be outputted during that step
    # @param [Proc] block
    # @return [Proc]
    def rest(&block)
      @rest = block
    end

    # Whether the reset event should fire
    # @param [Fixnum] pointer The sequencer pointer
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def reset?(pointer, data)
      !@reset.nil? && @reset.call(pointer, data)
    end

    # Whether the rest event should fire
    # @param [Fixnum] pointer The sequencer pointer
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def rest?(pointer, data)
      !@rest.nil? && @rest.call(pointer, data)
    end

    # Set the stop trigger. When true, the sequencer will stop
    # @param [Proc] block
    # @return [Proc]
    def stop(&block)
      @stop = block
    end

    # Whether to fire the stop event
    # @param [Fixnum] pointer The sequencer pointer
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def stop?(pointer, data)
      !@stop.nil? && @stop.call(pointer, data)
    end
        
    # Shortcut to trigger a rest event on a given interval of ticks
    # @param [Fixnum, nil] num The number of ticks or nil to cancel existing triggers
    # @return [Fixnum, nil]
    def rest_every(num)
      if num.nil?
        @rest = nil
      else
        rest { |pointer| pointer % num == 0 }
        num
      end
    end

    # Shortcut to trigger a reset even on a given interval of ticks
    # @param [Fixnum, nil] num The number of ticks or nil to cancel existing triggers
    # @return [Fixnum, nil]
    def reset_every(num)
      if num.nil?
        @reset = nil
      else
        reset { |pointer| pointer % num == 0 }
        num
      end
    end
            
  end
  
end

