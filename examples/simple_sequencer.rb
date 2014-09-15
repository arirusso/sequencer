#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

# A sequencer that loops through the sequence ten times, printing the current step

require "sequencer"

sequence = [1,2,3,4]
sequencer = Sequencer.new

sequencer.loop.range = 0..5

clock = Sequencer::Clock.new(120)
clock.event.tick { sequencer.exec(sequence) }

sequencer.trigger.stop { sequencer.loop.count == 10 }
sequencer.event.perform { |data| p data }
sequencer.event.stop { clock.stop }

clock.start(:blocking => true)
