module Sequencer 

  class State
    
    attr_accessor :pointer, :loop_count
    attr_reader :loop

    # @param [Hash] options
    # @option options [Array<Fixnum>, FalseClass, Fixnum, Range] :loop The loop range
    def initialize(options = {})
      @loop_count = 0
      @loop = get_loop_range(options[:loop]) unless options[:loop].nil?
      @pointer = get_start_pointer
    end

    # Set the loop range
    # @param [Array<Fixnum>, FalseClass, Fixnum, Range] value
    # @return [FalseClass, Range]
    def loop=(value)
      @loop = get_loop_range(value)
    end
    
    # Iterate to the next step
    # @param [Hash] options
    # @option options [Fixnum] :length The total length of the sequence (for looping)
    # @return [Boolean]
    def step(options = {})
      reset?(options) ? reset : @pointer += 1
      true
    end
    
    # Iterate to the beginning of the sequence
    # @return [Boolean]
    def reset
      @pointer = get_start_pointer
      @loop_count += 1
      true
    end

    private

    # Should the pointer reset?
    def reset?(options = {})
      length = options[:length]
      is_sequence_end = !length.nil? && @pointer == length - 1
      has_loop = !@loop.nil? && !@loop.eql?(false)
      is_loop_end = has_loop && @pointer == @loop.end
      is_sequence_end || is_loop_end
    end

    def get_start_pointer
      @loop.nil? || @loop === false ? 0 : @loop.begin
    end

    # @param [Array<Fixnum>, Fixnum, Range] value
    # @return [FalseClass, Range]
    def get_loop_range(value)
      case value
      when Array then (value[0]..value[1])
      when Fixnum then (0..value)
      when FalseClass, Range then value
      end
    end
            
  end
  
end
