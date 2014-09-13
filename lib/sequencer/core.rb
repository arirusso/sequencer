module Sequencer 

  # The core sequencer
  class Core

    attr_reader :event, :trigger, :state

    def initialize
      @event = Event.new
      @trigger = EventTrigger.new
      @state = State.new
      @running = false
    end

    # Toggle start/stop
    # @return [Boolean]
    def toggle_start
      @state.running? ? stop : start
    end

    # Mark state as running and trigger start event
    # @return [Boolean]
    def start    
      @state.start
      @event.do_start(@state)
      true
    end

    # Mark state as not running and trigger stop event
    # @return [Boolean]
    def stop
      @state.stop
      @event.do_stop(@state)
      true            
    end

    # Execute a single cycle of sequencing (perform and step)
    # @param [Array] sequence The sequence to execute a single cycle of
    # @return [Boolean] Whether perform and step both finished
    def exec(sequence)
      perform(sequence) && step(sequence)
    end

    # Step the sequencer and fire the step event
    # @param [Array] sequence
    # @return [Boolean]
    def step(sequence)
      @state.step(sequence.length)
      @event.do_step(@state)
      true
    end

    # If a stop is triggered, stop. Otherwise if reset is triggered, reset. Finally,
    # fire the perform event on the current step of the sequence
    # @param [Array] sequence
    # @return [Boolean] True if perform event was fired
    def perform(sequence)
      data = sequence.at(@state.pointer)
      unless data.nil?
        if @trigger.stop?(@state, data)
          stop
          false
        else
          if @trigger.reset?(@state, data)
            @state.reset 
          end
          @event.do_perform(@state, data)
          true
        end
      end
    end

  end

  def self.new
    Core.new
  end

end
