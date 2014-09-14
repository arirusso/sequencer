module Sequencer 

  # A light wrapper for Topaz::Tempo that adds some event handling
  class Clock

    include Syncable
    extend Forwardable

    attr_reader :event
    def_delegators :@clock, :pause, :unpause

    # @param [Fixnum, UniMIDI::Input] tempo_or_input
    # @param [Hash] options
    # @option options [Array<UniMIDI::Output>, UniMIDI::Output] :outputs MIDI output device(s)       
    def initialize(tempo_or_input, options = {})
      @event = Event.new
      initialize_clock(tempo_or_input, options.fetch(:resolution, 128), :outputs => options[:outputs])
    end

    # Stop the clock
    def stop
      @clock.stop
    end

    # Start the clock
    # @param [Hash] options
    # @option options [Boolean] :blocking Whether to run in the foreground (also :focus, :foreground)
    # @option options [Boolean] :suppress_clock Whether this clock is a sync-slave
    # @return [Boolean]
    def start(options = {})
      clock_options = {}
      clock_options[:background] = ![:blocking, :focus, :foreground].any? { |k| !!options[k] }
      @clock.start(clock_options) unless !!options[:suppress_clock]
      Thread.abort_on_exception = true
      true
    end

    private

    def on_tick
      activate_sync { @event.do_tick }
    end

    def initialize_clock(tempo_or_input, resolution, options = {})
      @clock = Topaz::Tempo.new(tempo_or_input, :midi => options[:outputs]) 
      @clock.interval = @clock.interval * (resolution / @clock.interval)
      @clock.on_tick { on_tick }
    end

    class Event

      include Syncable::Event

      def tick(&block)
        @tick = block
      end

      def do_tick
        !@tick.nil? && @tick.call
      end

    end

  end
end
