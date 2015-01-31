require "helper"

class Sequencer::EventTriggerTest < Minitest::Test

  context "EventTrigger" do

    setup do
      @trigger = Sequencer::EventTrigger.new
    end

    context "#reset?" do

      setup do
        @has_run = false
        @trigger.reset { |p, d| @has_run = d }
      end

      should "fire stop trigger" do
        assert @trigger.reset?(0, true)
        assert @has_run = true
      end

    end

    context "#reset_every" do

      setup do
        @trigger.reset_every(3)
      end

      should "reset every three ticks" do
        3.times do |i|
          assert @trigger.reset?((i * 3) + 0, false)
          refute @trigger.reset?((i * 3) + 1, false)
          refute @trigger.reset?((i * 3) + 2, false)
        end
      end

    end

    context "#rest_every" do

      setup do
        @trigger.rest_every(3)
      end

      should "reset every three ticks" do
        3.times do |i|
          assert @trigger.rest?((i * 3) + 0, false)
          refute @trigger.rest?((i * 3) + 1, false)
          refute @trigger.rest?((i * 3) + 2, false)
        end
      end

    end

    context "#rest?" do

      setup do
        @has_run = false
        @trigger.rest { |p, d| @has_run = d }
      end

      should "fire stop trigger" do
        assert @trigger.rest?(0, true)
        assert @has_run = true
      end

    end

    context "#stop?" do

      setup do
        @has_run = false
        @trigger.stop { |p, d| @has_run = d }
      end

      should "fire stop trigger" do
        assert @trigger.stop?(0, true)
        assert @has_run = true
      end

    end

  end

end
