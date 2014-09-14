#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

# A sequencer that loops through the sequence ten times, printing the current step

require "sequencer"

sequence = [1,2,3,4]
sequencer = Sequencer.new

clock = Sequencer::Clock.new(120)
clock.event.tick { sequencer.exec(sequence) }

sequencer.trigger.stop { |state| state.repeat == 10 }
sequencer.event.perform { |state, data| puts data }
sequencer.event.stop { clock.stop }

clock.start(:blocking => true)
