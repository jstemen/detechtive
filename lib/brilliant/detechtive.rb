require 'logger'
require 'thor'
require 'json'

require_relative "../brilliant/detechtive/version"
require_relative "../brilliant/detechtive/graph"
require_relative "../brilliant/detechtive/node"
require_relative "../brilliant/detechtive/timeline_state"
require_relative "../brilliant/detechtive/cli"

module Brilliant
  module Detechtive

    Log = Logger.new(STDOUT)
    Log.level = Logger::WARN
  end
end
