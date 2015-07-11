module Brilliant
  module Detechtive
    class TimelineState

      # Holds message
      attr_accessor :state
      # An array of arrays.  Inter arrays represent possible order of events (a timeline)
      attr_accessor :timelines

      def initialize
        @timelines = [[]]
      end
    end
  end
end
