module Sequencer 

  class Event
          
    def initialize
      @stop = nil
      @step = nil
      @perform = nil
    end

    def step(&block)
      @step = block
    end

    def do_step(state)
      !@step.nil? && @step.call(state)
    end

    def stop(&block)
      @stop = block
    end

    def do_stop(state)
      !@stop.nil? && @stop.call(state)
    end

    def perform(&block)
      @perform = block
    end

    def do_perform(state, data)
      !@perform.nil? && @perform.call(state, data)
    end
                    
  end
  
end
