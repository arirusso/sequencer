require "helper"

class Sequencer::CoreTest < Test::Unit::TestCase
  
  context "Sequencer" do

    setup do
      @sequence = [1,2,3,4]
      @cache = []
      sequencer = Sequencer.new
      clock = Sequencer::Clock.new(120)
      clock.event.tick { sequencer.exec(@sequence) }
      sequencer.event.perform { |state, data| @cache << data }
      sequencer.trigger.stop { |state| state.repeat == 1 }
      sequencer.event.stop { clock.stop }
      clock.start(:focus => true)
    end

    should "create cache of sequence" do
      assert_equal @sequence, @cache
    end

  end
    
end

