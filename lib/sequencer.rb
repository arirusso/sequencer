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
require "sequencer/core"
require "sequencer/event"
require "sequencer/event_trigger"
require "sequencer/loop"
require "sequencer/sync"

module Sequencer
  
  VERSION = "0.0.3"
  
end
