#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')

# A sequencer that loops through the sequence twenty times, printing the current step
# The clock is controlled by a MIDI input

require 'sequencer'

sequence = [1, 2, 3, 4]
sequencer = Sequencer.new

input = UniMIDI::Input.gets
clock = Sequencer::Clock.new(input)

clock.event.tick { sequencer.exec(sequence) }

sequencer.trigger.stop { sequencer.loop.count == 20 }
sequencer.event.perform { |data| puts data }
sequencer.event.stop { clock.stop }

clock.start(blocking: true)
