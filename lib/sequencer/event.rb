module Sequencer 

  # Events that are fired by the sequencer
  class Event

    def initialize
      @next = {}
      @perform = []
      @step = []
      @stop = []
    end

    # Fire an event the next time the pointer reaches the given number
    # @param [Fixnum, nil] pointer The pointer number when the callback should be fired.  If nil, it will be fired whenever Event#do_next is called.
    # @param [Proc] block
    # @return [Array<Proc>]
    def next(pointer = nil, &block)
      @next[pointer] ||= []
      if block_given?
        @next[pointer].clear
        @next[pointer] << block
      end
      @next[pointer]
    end

    # Whether any callbacks exist for the given pointer (or nil)
    # @param [Fixnum, nil] pointer
    # @return [Boolean]
    def next?(pointer = nil)
      !@next[pointer].nil?
    end

    # @param [Fixnum, nil] pointer The pointer number (or nil) to fire callbacks for.
    # @param [Object] data The data for the current pointer
    # @return [Array<Object>]
    def do_next(pointer, data)
      keys = [pointer, nil]
      callbacks = keys.map { |key| @next.delete(key) }.flatten.compact
      callbacks.map(&:call)
    end

    # Set the step event
    # @param [Proc] block
    # @return [Proc]
    def step(&block)
      if block_given?
        @step.clear
        @step << block
      end
      @step
    end

    # Fire the step events
    # @return [Boolean]
    def do_step
      @step.map(&:call)
    end

    # Access the stop events
    # @param [Proc] block
    # @return [Proc]
    def stop(&block)
      if block_given?
        @stop.clear
        @stop << block
      end
      @stop
    end

    # Fire the stop event
    # @return [Boolean]
    def do_stop
      @stop.map(&:call)
    end

    # Set the perform event
    # @param [Proc] block
    # @return [Proc]
    def perform(&block)
      if block_given?
        @perform.clear
        @perform << block
      end
      @perform
    end

    # Fire the perform event
    # @param [Object] data Data for the current sequence step 
    # @return [Boolean]
    def do_perform(data)
      @perform.map { |callback| callback.call(data) }
    end
                    
  end
  
end
