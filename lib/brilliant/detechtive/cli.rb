module Brilliant
  module Detechtive
    class Cli < Thor
      desc "process FILE", "Find the longest sequence of events for event input."

      def process(file)
        str = File.read(file)
        json = JSON.parse str
        timeline_res = Graph.new.input json
        puts timeline_res.state
        puts timeline_res.timelines.to_json
      end

      default_task :process
    end
  end
end