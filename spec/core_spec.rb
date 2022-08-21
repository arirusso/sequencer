# frozen_string_literal: true

require 'helper'

describe Sequencer::Core do
  let(:sequencer) { Sequencer::Core.new }

  describe '#exec' do
    let(:sequence) { [1, 2, 3, 4] }

    it 'moves to next' do
      expect(sequencer.pointer).to eq(0)
      sequencer.exec(sequence)
      expect(sequencer.pointer).to eq(1)
    end

    it 'repeats' do
      sequencer.pointer = sequence.length - 1
      sequencer.exec(sequence)
      expect(sequencer.pointer).to eq(0)
    end

    it 'stops' do
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(true)
      expect(sequencer.trigger).to_not receive(:reset?)
      expect(sequencer.event).to_not receive(:do_perform)

      sequencer.exec(sequence)
    end

    it 'resets and fires event' do
      sequencer.pointer = 3
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(false)
      expect(sequencer.trigger).to receive(:reset?).exactly(:once).and_return(true)
      expect(sequencer.event).to receive(:do_perform).exactly(:once)

      sequencer.exec(sequence)
      expect(sequencer.pointer).to eq(1)
    end

    it 'fires event' do
      sequencer.pointer = 2
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(false)
      expect(sequencer.trigger).to receive(:reset?).exactly(:once).and_return(false)
      expect(sequencer.event).to receive(:do_perform).exactly(:once)

      sequencer.exec(sequence)
      expect(sequencer.pointer).to eq(3)
    end
  end

  describe '#step' do
    let(:sequence) { [1, 2, 3, 4] }
    before do
      expect(sequencer.event).to receive(:do_step).exactly(:once)
    end

    it 'moves to next' do
      expect(sequencer.pointer).to eq(0)
      sequencer.step(sequence)
      expect(sequencer.pointer).to eq(1)
    end

    it 'repeats' do
      sequencer.pointer = sequence.length - 1
      sequencer.step(sequence)
      expect(sequencer.pointer).to eq(0)
    end
  end

  describe '#perform' do
    let(:sequence) { [1, 2, 3, 4] }

    it 'stops' do
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(true)
      expect(sequencer.trigger).to_not receive(:reset?)
      expect(sequencer.event).to_not receive(:do_perform)
      sequencer.perform(sequence)
    end

    it 'resets and fires event' do
      sequencer.pointer = 3
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(false)
      expect(sequencer.trigger).to receive(:reset?).exactly(:once).and_return(true)
      expect(sequencer.event).to receive(:do_perform).exactly(:once)
      sequencer.perform(sequence)
      expect(sequencer.pointer).to eq(0)
    end

    it 'fires event' do
      sequencer.pointer = 3
      expect(sequencer.trigger).to receive(:stop?).exactly(:once).and_return(false)
      expect(sequencer.trigger).to receive(:reset?).exactly(:once).and_return(false)
      expect(sequencer.event).to receive(:do_perform).exactly(:once)
      sequencer.perform(sequence)
      expect(sequencer.pointer).to eq(3)
    end
  end
end
