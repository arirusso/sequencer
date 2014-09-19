require "helper"

class Sequencer::ClockTest < Test::Unit::TestCase

  context "Clock" do

    setup do
      @clock = Sequencer::Clock.new(120)
    end

    context "Clock#initialize" do

      should "get MIDI output" do
        output = Object.new
        @clock = Sequencer::Clock.new(120, :output => output)
        assert_not_nil @clock.midi_outputs
        assert_not_empty @clock.midi_outputs
        assert @clock.midi_outputs.include?(output)
      end

    end

    context "Clock#add_midi_output" do

      should "add MIDI output" do
        output = Object.new
        refute @clock.midi_outputs.include?(output)
        @clock.add_midi_output(output)
        assert_not_nil @clock.midi_outputs
        assert_not_empty @clock.midi_outputs
        assert @clock.midi_outputs.include?(output)
      end

    end

    context "Clock#remove_midi_output" do

      should "remove MIDI output" do
        output = Object.new
        refute @clock.midi_outputs.include?(output)
        @clock.add_midi_output(output)
        assert_not_nil @clock.midi_outputs
        assert_not_empty @clock.midi_outputs
        assert @clock.midi_outputs.include?(output)
        @clock.remove_midi_output(output)
        refute @clock.midi_outputs.include?(output)
      end

    end

    context "Clock#tempo" do

      should "get tempo" do
        assert_equal 120, @clock.tempo
      end

    end

    context "Clock#tempo=" do

      should "set tempo" do
        @clock.tempo = 58
        assert_equal 58, @clock.tempo
      end

    end

    context "Clock::Event#tick" do

      setup do
        @flag = false
        @flag2 = false
      end

      should "assign single callback" do
        @clock.event.tick { @flag = true }
        refute @flag
        @clock.event.do_tick
        assert @flag
      end

      should "reassign single callback" do
        @clock.event.tick { @flag = true }
        @clock.event.tick { @flag2 = true }
        refute @flag
        refute @flag2
        @clock.event.do_tick
        refute @flag
        assert @flag2
      end

      should "allow multiple callbacks" do
        @clock.event.tick { @flag = true }
        @clock.event.tick << proc { @flag2 = true }
        refute @flag
        refute @flag2
        @clock.event.do_tick
        assert @flag
        assert @flag2
      end
      
    end

  end

end


