require "helper"

class Sequencer::CoreTest < Test::Unit::TestCase

  context "Core" do

    setup do
      @sequencer = Sequencer::Core.new
      @clock = Sequencer::Clock.new(120)
      @clock.event.tick { @sequencer.exec(@sequence) }
      @sequencer.event.stop { @clock.stop }
    end

    context "#toggle_start" do
      
    end

    context "#start" do

    end

    context "#stop" do

    end

    context "#running=" do

    end

    context "#exec" do

    end

    context "#step" do

    end

    context "#perform" do

    end

    context "Functional" do

      setup do
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

