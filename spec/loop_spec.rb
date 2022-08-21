# frozen_string_literal: true

require 'helper'

describe Sequencer::Loop do
  let(:loop) { Sequencer::Loop.new }

  describe '#to_range' do
    it 'converts array' do
      expect(loop.send(:to_range, [1, 6])).to eq(1..6)
    end

    it 'converts number' do
      expect(loop.send(:to_range, 9)).to eq(0..9)
    end

    it 'passes range' do
      expect(loop.send(:to_range, 5..8)).to eq(5..8)
    end
  end

  describe '#start' do
    context 'when default loop' do
      it 'always has 0 as start' do
        expect(loop.default?).to eq(true)
        expect(loop.start).to eq(0)
      end
    end

    context 'when custom loop' do
      before do
        loop.range = 3..6
      end

      it 'has custom start point' do
        expect(loop.default?).to eq(false)
        expect(loop.start).to eq(3)
      end
    end
  end

  describe '#in_bounds?' do
    context 'when default loop' do
      context 'when number in range' do
        it 'returns true' do
          expect(loop.in_bounds?(3, length: 10)).to eq(true)
        end
      end

      context 'when number is out of range' do
        it 'returns false' do
          expect(loop.in_bounds?(10, length: 8)).to eq(false)
        end
      end
    end

    context 'when custom loop' do
      before do
        loop.range = 0..6
      end

      context 'when number in range' do
        it 'returns true' do
          expect(loop.in_bounds?(5)).to eq(true)
        end
      end

      context 'when number is out of range' do
        it 'returns false' do
          expect(loop.in_bounds?(7)).to eq(false)
        end
      end
    end
  end
end
