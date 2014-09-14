module Sequencer 

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
      clock_options[:background] = true unless !!options[:focus] || !!options[:foreground] || !!options[:blocking]
      @clock.start(clock_options) unless !!options[:suppress_clock]
      Thread.abort_on_exception = true
      true
    end

    private

    def on_tick
      sync_immediate if @event.sync?
      @event.do_tick
      sync_enqueued
    end

    def initialize_clock(tempo_or_input, resolution, options = {})
      @clock = Topaz::Tempo.new(tempo_or_input, :midi => options[:outputs]) 
      @clock.interval = @clock.interval * (resolution / @clock.interval)
      @clock.on_tick { on_tick }
    end

    class Event

      def initialize
        @sync = nil
        @tick = nil
      end

      def sync(&block)
        @sync = block
      end

      def sync?
        !@sync.nil? && @sync.call
      end

      def tick(&block)
        @tick = block
      end

      def do_tick
        !@tick.nil? && @tick.call
      end

    end

  end
end
