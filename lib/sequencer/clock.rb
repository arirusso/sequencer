module Sequencer 

  # A light wrapper for Topaz::Tempo that adds some event handling
  class Clock

    extend Forwardable

    attr_reader :event
    def_delegators :@clock, :pause, :stop, :unpause

    # @param [Fixnum, UniMIDI::Input] tempo_or_input
    # @param [Hash] options
    # @option options [Array<UniMIDI::Output>, UniMIDI::Output] :output (also: :outputs) MIDI output device(s)     
    def initialize(tempo_or_input, options = {})
      @event = Event.new
      outputs = options[:output] || options[:outputs] 
      resolution = options.fetch(:resolution, 128)
      initialize_clock(tempo_or_input, resolution, :outputs => outputs)
    end

    # Start the clock
    # @param [Hash] options
    # @option options [Boolean] :background Whether to run in the background
    # @option options [Boolean] :blocking Whether to run in the foreground (also :focus, :foreground)
    # @option options [Boolean] :suppress_clock Whether this clock is a sync-slave
    # @return [Boolean]
    def start(options = {})
      clock_options = {}
      clock_options[:background] = !!options[:background]
      clock_options[:background] ||= ![:blocking, :focus, :foreground].any? { |key| !!options[key] }
      @clock.start(clock_options) unless !!options[:suppress_clock]
      Thread.abort_on_exception = true
    end

    private

    # Action taken by the clock on a tick.  Fires the tick event
    def on_tick
      @event.do_tick
    end

    # Instantiate the underlying clock object
    # @param [Fixnum, UniMIDI::Input] tempo_or_input
    # @param [Fixnum] resolution
    # @param [Hash] options
    # @option options [Array<UniMIDI::Output>, UniMIDI::Output] :output MIDI output device(s) 
    def initialize_clock(tempo_or_input, resolution, options = {})
      @clock = Topaz::Tempo.new(tempo_or_input, :midi => options[:output]) 
      @clock.interval = @clock.interval * (resolution / @clock.interval)
      @clock.on_tick { on_tick }
    end

    # Clock event callbacks
    class Event

      def initialize
        @tick = []
      end

      # Access the tick event callback
      # @param [Proc] block
      # @return [Proc]
      def tick(&block)
        if block_given?
          @tick.clear
          @tick << block
        end
        @tick
      end

      # Fire the tick event callback
      # @return [Boolean]
      def do_tick
        !@tick.empty? && @tick.map(&:call)
      end

    end
  end
end
