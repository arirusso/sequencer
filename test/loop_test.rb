require "helper"

class Sequencer::LoopTest < Minitest::Test

  context "Loop" do

    setup do
      @loop = Sequencer::Loop.new
    end

    context "#to_range" do

      should "convert array" do
        assert_equal 1..6, @loop.send(:to_range, [1, 6])
      end

      should "convert number" do
        assert_equal 0..9, @loop.send(:to_range, 9)
      end

      should "pass range" do
        assert_equal 5..8, @loop.send(:to_range, 5..8)
      end

    end

     context "#start" do

      context "default loop" do

        should "always have 0 as start" do
          assert @loop.default?
          assert_equal 0, @loop.start
        end

      end

      context "custom loop" do

        setup do
          @loop.range = 3..6
        end

        should "have custom start point" do
          refute @loop.default?
          assert_equal 3, @loop.start
        end

      end

    end

    context "#in_bounds?" do

      context "default loop" do

        should "include number in range" do
          assert @loop.in_bounds?(3, :length => 10)
        end

        should "not include number out of range" do
          refute @loop.in_bounds?(10, :length => 8)
        end

      end

      context "custom loop" do

        setup do
          @loop.range = 0..6
        end

        should "include number in range" do
          assert @loop.in_bounds?(5)
        end

        should "not include number out of range" do
          refute @loop.in_bounds?(7)
        end

      end

    end

  end

end
