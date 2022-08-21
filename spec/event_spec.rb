# frozen_string_literal: true

require 'helper'

describe Sequencer::EventTrigger do
  let(:trigger) { Sequencer::Event.new }
  let(:cache) { [] }

  describe '#next' do
    it 'fires callback' do
      trigger.next(3) do |_p, d|
        cache << d
      end
      expect(cache).to be_empty
      expect(trigger.next?(3)).to eq(true)
      expect(trigger.next?(2)).to eq(false)
      trigger.do_next(3, true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'replaces callback' do
      trigger.next(3) do |_p, d|
        cache << d
      end
      expect(trigger.next?(3)).to eq(true)
      trigger.next(3) do |_p, d|
        cache << d
      end
      expect(cache).to be_empty
      expect(trigger.next?(3)).to eq(true)
      expect(trigger.next?(2)).to eq(false)
      trigger.do_next(3, true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'adds callback' do
      3.times do
        trigger.next(3) << proc do |_p, d|
          cache << d
        end
      end
      expect(cache).to be_empty
      expect(trigger.next?(3)).to eq(true)
      expect(trigger.next?(2)).to eq(false)
      trigger.do_next(3, true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(3)
    end
  end

  describe '#perform' do
    it 'fires callback' do
      trigger.perform do |d|
        cache << d
      end
      expect(cache).to be_empty
      trigger.do_perform(true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'replaces callback' do
      trigger.perform do |d|
        cache << d
      end
      trigger.perform do |d|
        cache << d
      end
      expect(cache).to be_empty
      trigger.do_perform(true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'adds callback' do
      3.times do
        trigger.perform << proc do |_p, d|
          cache << d
        end
      end
      expect(cache).to be_empty
      trigger.do_perform(true)
      expect(cache).to_not be_empty
      expect(cache.size).to eq(3)
    end
  end

  describe '#step' do
    it 'fires callback' do
      trigger.step do
        cache << true
      end
      expect(cache).to be_empty
      trigger.do_step
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'replaces callback' do
      trigger.step do
        cache << true
      end
      trigger.step do
        cache << true
      end
      expect(cache).to be_empty
      trigger.do_step
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'adds callback' do
      3.times do
        trigger.step << proc do
          cache << true
        end
      end
      expect(cache).to be_empty
      trigger.do_step
      expect(cache).to_not be_empty
      expect(cache.size).to eq(3)
    end
  end

  describe '#stop' do
    it 'fires callback' do
      trigger.stop do
        cache << true
      end
      expect(cache).to be_empty
      trigger.do_stop
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'replaces callback' do
      trigger.stop do
        cache << true
      end
      trigger.stop do
        cache << true
      end
      expect(cache).to be_empty
      trigger.do_stop
      expect(cache).to_not be_empty
      expect(cache.size).to eq(1)
    end

    it 'adds callback' do
      3.times do
        trigger.stop << proc do
          cache << true
        end
      end
      expect(cache).to be_empty
      trigger.do_stop
      expect(cache).to_not be_empty
      expect(cache.size).to eq(3)
    end
  end
end
