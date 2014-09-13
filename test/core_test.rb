require "helper"

class Sequencer::CoreTest < Test::Unit::TestCase

  context "Core" do

    setup do
      @sequencer = Sequencer::Core.new
    end

    context "#exec" do

      setup do
        @sequence = [1,2,3,4]
      end

      should "move to next" do  
        assert_equal 0, @sequencer.state.pointer
        @sequencer.exec(@sequence)
        assert_equal 1, @sequencer.state.pointer
      end

      should "do repeat" do
        @sequencer.state.pointer = @sequence.length - 1
        @sequencer.exec(@sequence)
        assert_equal 0, @sequencer.state.pointer
      end

      should "stop" do
        @sequencer.trigger.expects(:stop?).once.returns(true)
        @sequencer.trigger.expects(:reset?).never
        @sequencer.event.expects(:do_perform).never
        @sequencer.exec(@sequence)
      end

      should "reset and fire event" do
        @sequencer.state.pointer = 3
        @sequencer.trigger.expects(:stop?).once.returns(false)
        @sequencer.trigger.expects(:reset?).once.returns(true)
        @sequencer.event.expects(:do_perform).once
        @sequencer.exec(@sequence)
        assert_equal 1, @sequencer.state.pointer
      end

      should "fire event" do
        @sequencer.state.pointer = 2
        @sequencer.trigger.expects(:stop?).once.returns(false)
        @sequencer.trigger.expects(:reset?).once.returns(false)
        @sequencer.event.expects(:do_perform).once
        @sequencer.exec(@sequence)
        assert_equal 3, @sequencer.state.pointer
      end

    end

    context "#step" do

      setup do
        @sequence = [1,2,3,4]
        @sequencer.event.expects(:do_step).once
      end

      should "move to next" do  
        assert_equal 0, @sequencer.state.pointer
        @sequencer.step(@sequence)
        assert_equal 1, @sequencer.state.pointer
      end

      should "do repeat" do
        @sequencer.state.pointer = @sequence.length - 1
        @sequencer.step(@sequence)
        assert_equal 0, @sequencer.state.pointer
      end

    end

    context "#perform" do

      setup do
        @sequence = [1,2,3,4]
      end

      should "stop" do
        @sequencer.trigger.expects(:stop?).once.returns(true)
        @sequencer.trigger.expects(:reset?).never
        @sequencer.event.expects(:do_perform).never
        @sequencer.perform(@sequence)
      end

      should "reset and fire event" do
        @sequencer.state.pointer = 3
        @sequencer.trigger.expects(:stop?).once.returns(false)
        @sequencer.trigger.expects(:reset?).once.returns(true)
        @sequencer.event.expects(:do_perform).once
        @sequencer.perform(@sequence)
        assert_equal 0, @sequencer.state.pointer
      end

      should "fire event" do
        @sequencer.state.pointer = 3
        @sequencer.trigger.expects(:stop?).once.returns(false)
        @sequencer.trigger.expects(:reset?).once.returns(false)
        @sequencer.event.expects(:do_perform).once
        @sequencer.perform(@sequence)
        assert_equal 3, @sequencer.state.pointer
      end

    end

    context "Functional" do

      setup do
        @clock = Sequencer::Clock.new(120)
        @clock.event.tick { @sequencer.exec(@sequence) }
        @sequencer.event.stop { @clock.stop }
        @sequence = [1,2,3,4]
        @cache = []
        @sequencer.event.perform { |state, data| @cache << data }
        @sequencer.trigger.stop { |state| state.repeat == 1 }
        @clock.start(:focus => true)
      end

      should "create cache of sequence" do
        assert_equal @sequence, @cache
      end

    end


  end

end

