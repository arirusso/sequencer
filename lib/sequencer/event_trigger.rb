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
     # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def reset?(data)
      !@reset.nil? && @reset.call(data)
    end

    # Set the stop trigger. When true, the sequencer will stop
    # @param [Proc] block
    # @return [Proc]
    def stop(&block)
      @stop = block
    end

    # Whether to fire the stop event
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def stop?(data)
      !@stop.nil? && @stop.call(data)
    end
        
    # Bind an event when the instrument plays a rest on every given beat
    # Passing in nil will cancel any existing rest events 
    # @param [Fixnum] num The number of recurring beats to rest on
    # @return [Fixnum, nil]
    def rest_every(num)
      if num.nil?
        @rest_when = nil
      else
        rest_when { |step| step.pointer % num == 0 }
        num
      end
    end

    # Bind an event where the instrument resets on every <em>num<em> beat
    # passing in nil will cancel any reset events 
    def reset_every(num)
      if num.nil?
        @reset_when = nil
      else
        reset_when { |step| step.pointer % num == 0 }
        num
      end
    end
            
  end
  
end

