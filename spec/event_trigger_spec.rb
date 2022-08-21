# frozen_string_literal: true

require 'helper'

describe Sequencer::EventTrigger do
  let(:trigger) { Sequencer::EventTrigger.new }

  describe '#reset?' do
    before do
      @has_run = false
      trigger.reset { |_p, d| @has_run = d }
    end

    it 'fires stop trigger' do
      expect(trigger.reset?(0, true)).to eq(true)
      expect(@has_run).to eq(true)
    end
  end

  describe '#reset_every' do
    before do
      trigger.reset_every(3)
    end

    it 'resets every three ticks' do
      3.times do |i|
        expect(trigger.reset?((i * 3) + 0, false)).to eq(true)
        expect(trigger.reset?((i * 3) + 1, false)).to eq(false)
        expect(trigger.reset?((i * 3) + 2, false)).to eq(false)
      end
    end
  end

  describe '#rest_every' do
    before do
      trigger.rest_every(3)
    end

    it 'resets every three ticks' do
      3.times do |i|
        expect(trigger.rest?((i * 3) + 0, false)).to eq(true)
        expect(trigger.rest?((i * 3) + 1, false)).to eq(false)
        expect(trigger.rest?((i * 3) + 2, false)).to eq(false)
      end
    end
  end

  describe '#rest?' do
    before do
      @has_run = false
      trigger.rest { |_p, d| @has_run = d }
    end

    it 'fires stop trigger' do
      expect(trigger.rest?(0, true)).to eq(true)
      expect(@has_run).to eq(true)
    end
  end

  describe '#stop?' do
    before do
      @has_run = false
      trigger.stop { |_p, d| @has_run = d }
    end

    it 'fires stop trigger' do
      expect(trigger.stop?(0, true)).to eq(true)
      expect(@has_run).to eq(true)
    end
  end
end
