module Sequencer 

  # The core sequencer
  class Core

    attr_reader :event, :loop, :trigger
    attr_accessor :pointer

    def initialize
      @event = Event.new
      @loop = Loop.new
      @pointer = 0
      @trigger = EventTrigger.new
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
      if reset_pointer?(:length => sequence.length)
        reset_pointer
      else
        @pointer += 1
      end
      @event.do_step
      true
    end

    # If a stop is triggered, stop. Otherwise if reset is triggered, reset. Finally,
    # fire the perform event on the current step of the sequence
    # @param [Array] sequence
    # @return [Boolean] True if perform event was fired
    def perform(sequence)
      data = sequence.at(@pointer)
      @event.do_next(@pointer, data) if @event.next?(@pointer)
      if @trigger.stop?(@pointer, data)
        @event.do_stop
        false
      else
        reset_pointer if @trigger.reset?(@pointer, data)
        @event.do_perform(data)
        true
      end
    end

    def reset_pointer
      @pointer = @loop.start
      @loop.step
    end

    private

    def reset_pointer?(options = {})
      !@loop.disabled? && !@loop.in_bounds?(@pointer + 1, :length => options[:length])
    end

  end

  # Shortcut to the Core constructor
  # @return [Core]
  def self.new
    Core.new
  end

end
