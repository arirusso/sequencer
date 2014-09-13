dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + "/../lib"

require "test/unit"
require "mocha/test_unit"
require "shoulda-context"
require "sequencer"

module TestHelper
  
  def self.select_midi_output
    $midi_output = UniMIDI::Output.gets
  end
         
end

TestHelper.select_devices
