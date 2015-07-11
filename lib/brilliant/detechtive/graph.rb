module Brilliant
  module Detechtive
    class Graph

      def initialize
        @name_to_node_map = {}
      end

      def input(arry_of_arrays)
        arry_of_arrays.each { |a|
          process_event_array a
        }
        process
      end

      def process
        heads = @name_to_node_map.values.select { |n| n.upstream.empty? }

        head = heads.first

        arr = recursive_traverse head, []
        Result.new("Merge is possible", [arr])
      end

      def recursive_traverse(node, visited)
        puts "visiting #{node.name}"
        visited << node.name
        if node.downstream.empty?

          puts "#{node.name} has no downstream nodes"
          return visited
        elsif node.downstream.size == 1
          return recursive_traverse node.downstream.first, visited
        else

          forks = node.downstream.collect { |down|
            recursive_traverse(down, [])
          }

          visited << forks.sort_by(&:size).last
          visited.flatten!
=begin
          common = forks.inject{|sum,nex| sum & nex}

          base_fork = nil
          other_fork = nil
          forks.each{|fork|
            if fork.find_index common == 0
              base_fork = fork
            else
              other_fork = fork
            end

          }
=end

        end
        visited
      end


      def process_event_array(array)
        last = nil
        array.each_with_index { |name, i|
          last = @name_to_node_map[array[i-1]] if i > 0
          saved = @name_to_node_map[name] || Node.new(name)
          saved.add_upstream last
          @name_to_node_map[name]=saved
        }
      end

    end
  end
end