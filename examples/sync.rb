#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')

# Sync two sequencers to the same clock

require 'sequencer'

sequence1 = [1, 2, 3, 4]
sequence2 = [9, 8, 7, 6]

sequencers = [Sequencer.new, Sequencer.new]

clock = Sequencer::Clock.new(120)
clock.event.tick { sequencers[0].exec(sequence1) }

sequencers[0].event.next(3) do
  clock.event.tick << proc { sequencers[1].exec(sequence2) }
end

sequencers.each do |sequencer|
  sequencer.trigger.stop { sequencer.loop.count == 10 }
  sequencer.event.perform { |data| p data }
  sequencer.event.stop { clock.stop }
end

clock.start(blocking: true)
