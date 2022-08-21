# frozen_string_literal: true

module Sequencer
  # Define a looping behavior for the sequencer
  class Loop
    attr_reader :count, :range

    def initialize
      @count = 0
      @range = nil
      @is_disabled = false
    end

    # Set the loop range
    # @param [Array<Fixnum>, FalseClass, Fixnum, Range] value
    # @return [FalseClass, Range]
    def range=(value)
      @range = to_range(value)
    end

    # The starting pointer position for this loop.  For the default loop, position is 0
    # @return [Fixnum]
    def start
      default? ? 0 : @range.begin
    end

    # Mark a completed loop and return the start position
    # @return [Fixnum] The loop start position (see Loop#start)
    def next
      @count += 1
      start
    end

    # Is this a default loop?  The default loops around the start and end of the sequence
    # @return [Boolean]
    def default?
      @range.nil?
    end

    # Is looping disabled?
    # @return [Boolean]
    def disabled?
      @is_disabled
    end

    # Disable looping
    # @return [Boolean]
    def disable
      @is_disabled = true
    end

    # Is the given pointer position in bounds of the loop?
    # @param [Fixnum] pointer The pointer position to compare bounds to
    # @param [Hash] options
    # @option options [Fixnum] :length The sequence length (required if default loop is being used)
    # @return [Boolean]
    def in_bounds?(pointer, options = {})
      length = options[:length]
      range = default? ? 0..(length - 1) : @range
      range.include?(pointer)
    end

    private

    # Convert the given value to a range
    # @param [Array<Fixnum>, Fixnum, Range] value
    # @return [FalseClass, Range]
    def to_range(value)
      case value
      when Array then (value[0]..value[1])
      when Integer then (0..value)
      when Range then value
      end
    end
  end
end
