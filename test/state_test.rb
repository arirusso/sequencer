require "helper"

class Sequencer::StateTest < Test::Unit::TestCase

  context "State" do

    setup do
      @state = Sequencer::State.new
    end

    context "#step" do
      
      should "move to next" do
        @state.pointer = 1
        @state.step(3)
        assert_equal 2, @state.pointer
      end

      should "reset" do
        @state.pointer = 2
        @state.step(3)
        assert_equal 0, @state.pointer
      end

    end

    context "#reset" do

      should "reset" do
        @state.pointer = 2
        @state.reset
        assert_equal 0, @state.pointer
      end

    end

  end

end


