module Sequencer 

  # Events that are fired by the sequencer
  class Event

    def next(pointer = nil, &block)
      @next = { 
        :pointer => pointer,
        :proc => block
      }
    end

    def next?(pointer = nil)
      !@next.nil? && @next[:pointer] == pointer
    end

    def do_next(data)
      @next[:proc].call(data)
      @next = nil
    end

    # Set the step event
    # @param [Proc] block
    # @return [Proc]
    def step(&block)
      @step = block
    end

    # Fire the step event
    # @return [Boolean]
    def do_step
      !@step.nil? && @step.call
    end

    # Set the stop event
    # @param [Proc] block
    # @return [Proc]
    def stop(&block)
      @stop = block
    end

    # Fire the stop event
    # @return [Boolean]
    def do_stop
      !@stop.nil? && @stop.call
    end

    # Set the perform event
    # @param [Proc] block
    # @return [Proc]
    def perform(&block)
      @perform = block
    end

    # Fire the perform event
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def do_perform(data)
      !@perform.nil? && @perform.call(data)
    end
                    
  end
  
end
