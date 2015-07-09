module Brilliant
  module Detechtive
    class Graph
      def initialize
        @name_to_node_map = {}
      end

      def input(array)
        last = nil
        array.each_with_index { |name, i|
          last = @name_to_node_map[array[i-1]] if i > 1
          saved = @name_to_node_map[name] || Node.new(name)
          saved.add_upstream last
          @name_to_node_map[name]=saved
        }
      end

    end
  end
end