module Sequencer 

  # Events that are fired by the sequencer
  class Event
          
    def initialize
      @step = nil
      @stop = nil
      @perform = nil
    end

    # Set the step event
    # @param [Proc] block
    # @return [Proc]
    def step(&block)
      @step = block
    end

    # Fire the step event
    # @param [State] The sequencer state
    # @return [Boolean]
    def do_step(state)
      !@step.nil? && @step.call(state)
    end

    # Set the stop event
    # @param [Proc] block
    # @return [Proc]
    def stop(&block)
      @stop = block
    end

    # Fire the stop event
    # @param [State] The sequencer state
    # @return [Boolean]
    def do_stop(state)
      !@stop.nil? && @stop.call(state)
    end

    # Set the perform event
    # @param [Proc] block
    # @return [Proc]
    def perform(&block)
      @perform = block
    end

    # Fire the perform event
    # @param [State] state The sequencer state
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def do_perform(state, data)
      !@perform.nil? && @perform.call(state, data)
    end
                    
  end
  
end
