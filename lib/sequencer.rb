#
# Sequencer
# Perform a sequence of events at tempo
#
# (c)2011-2014 Ari Russo
# Licensed under Apache 2.0
# 

# libs
require "forwardable"
require "topaz"

# modules
require "sequencer/syncable"

# classes
require "sequencer/clock"
require "sequencer/event"
require "sequencer/event_trigger"
require "sequencer/core"
require "sequencer/state"
require "sequencer/sync"

module Sequencer
  
  VERSION = "0.0.3"
  
end
