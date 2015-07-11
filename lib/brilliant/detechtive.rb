require "brilliant/detechtive/version"
require_relative "../brilliant/detechtive/graph"
require_relative "../brilliant/detechtive/node"
require_relative "../brilliant/detechtive/timeline_state"
require 'logger'

module Brilliant
  module Detechtive

    Log = Logger.new(STDOUT)
    Log.level = Logger::DEBUG
  end
end
