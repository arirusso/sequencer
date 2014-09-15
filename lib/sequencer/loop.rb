module Sequencer

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

    def start
      default? ? 0 : @range.begin
    end

    def step
      @count += 1
    end

    def default?
      @range.nil?
    end

    def disabled?
      @is_disabled
    end

    def disable
      @is_disabled = true
    end

    def in_bounds?(num, options = {})
      length = options[:length]
      range = default? ? 0..(length-1) : @range
      range.include?(num)
    end

    private

    # @param [Array<Fixnum>, Fixnum, Range] value
    # @return [FalseClass, Range]
    def to_range(value)
      case value
      when Array then (value[0]..value[1])
      when Fixnum then (0..value)
      when Range then value
      end
    end


    
  end
end
