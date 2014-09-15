#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

# Sync two sequencers to the same clock

require "sequencer"

sequence_1 = [1,2,3,4]
sequence_2 = [9,8,7,6]

sequencers = [Sequencer.new, Sequencer.new]

clock = Sequencer::Clock.new(120)
clock.event.tick { sequencers[0].exec(sequence_1) }

sequencers[0].event.next(3) do
  clock.event.tick << Proc.new { sequencers[1].exec(sequence_2) }
end

sequencers.each { |sequencer| sequencer.trigger.stop { sequencer.loop.count == 10 } }
sequencers.each { |sequencer| sequencer.event.perform { |data| p data } }
sequencers.each { |sequencer| sequencer.event.stop { clock.stop } }

clock.start(:blocking => true)
