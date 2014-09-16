require "helper"

class Sequencer::EventTriggerTest < Test::Unit::TestCase

  context "EventTrigger" do

    setup do
      @trigger = Sequencer::Event.new
      @cache = []
    end

    context "#next" do

      should "fire callback" do
        @trigger.next(3) do |p, d|
          @cache << d
        end
        assert @cache.empty?
        assert @trigger.next?(3)
        refute @trigger.next?(2)
        @trigger.do_next(3, true)
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "replace callback" do
        @trigger.next(3) do |p, d|
          @cache << d
        end
        assert @trigger.next?(3)
        @trigger.next(3) do |p, d|
          @cache << d
        end
        assert @cache.empty?
        assert @trigger.next?(3)
        refute @trigger.next?(2)
        @trigger.do_next(3, true)
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "add callback" do
        3.times do
          @trigger.next(3) << proc do |p, d|
            @cache << d
          end
        end
        assert @cache.empty?
        assert @trigger.next?(3)
        refute @trigger.next?(2)
        @trigger.do_next(3, true)
        refute @cache.empty?
        assert_equal 3, @cache.size
      end

    end

    context "#perform" do

      should "fire callback" do
        @trigger.perform do |d|
          @cache << d
        end
        assert @cache.empty?
        @trigger.do_perform(true)
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "replace callback" do
        @trigger.perform do |d|
          @cache << d
        end
        @trigger.perform do |d|
          @cache << d
        end
        assert @cache.empty?
        @trigger.do_perform(true)
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "add callback" do
        3.times do
          @trigger.perform << proc do |p, d|
            @cache << d
          end
        end
        assert @cache.empty?
        @trigger.do_perform(true)
        refute @cache.empty?
        assert_equal 3, @cache.size
      end

    end

    context "#step" do

      should "fire callback" do
        @trigger.step do
          @cache << true
        end
        assert @cache.empty?
        @trigger.do_step
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "replace callback" do
        @trigger.step do
          @cache << true
        end
        @trigger.step do
          @cache << true
        end
        assert @cache.empty?
        @trigger.do_step
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "add callback" do
        3.times do
          @trigger.step << proc do
            @cache << true
          end
        end
        assert @cache.empty?
        @trigger.do_step
        refute @cache.empty?
        assert_equal 3, @cache.size
      end

    end

    context "#stop" do

      should "fire callback" do
        @trigger.stop do
          @cache << true
        end
        assert @cache.empty?
        @trigger.do_stop
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "replace callback" do
        @trigger.stop do
          @cache << true
        end
        @trigger.stop do
          @cache << true
        end
        assert @cache.empty?
        @trigger.do_stop
        refute @cache.empty?
        assert_equal 1, @cache.size
      end

      should "add callback" do
        3.times do
          @trigger.stop << proc do
            @cache << true
          end
        end
        assert @cache.empty?
        @trigger.do_stop
        refute @cache.empty?
        assert_equal 3, @cache.size
      end

    end

  end

end



