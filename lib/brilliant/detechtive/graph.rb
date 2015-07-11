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

        recursive_traverse head, TimelineState.new
      end

      def recursive_traverse(node, current_state)
        puts "visiting #{node.name}"
        current_state.timeline << node.name
        if node.downstream.empty?

          puts "#{node.name} has no downstream nodes"
          return current_state
        elsif node.downstream.size == 1
          return recursive_traverse node.downstream.first, current_state
        else

          forks = node.downstream.collect { |down|
            recursive_traverse(down, TimelineState.new).timeline
          }
          common_elems = forks.inject { |sum, nex| sum & nex }
          #binding.pry

          common_elem = common_elems.first
          base_forks = forks.select { |f| f.first.equal? common_elem }
          if base_forks.empty?
            current_state.state = "Partial merge is possible"
            #partial merge or no merge
            jumbled = []

            com_index = forks.first.find_index common_elem
            agreed = forks.first.slice(com_index, forks.first.size - 1)

            dispute = forks.collect { |f|
              term = f.find_index common_elem
              f.slice(0, term)
            }

            versions = []
            #could iterate over permuations of parallel events here to list all possible timelines, but outside of problem description
            dispute.each{ |p|
              versions << (current_state.timeline + p + agreed).flatten
            }

            current_state.timeline = versions


          elsif base_forks.size == 1
            current_state.state = "Merge is possible"
            puts "full merge possilbe"

            current_state.timeline = [(current_state.timeline + forks.sort_by(&:size).last).flatten]
          else
            raise " only one base fork should be found!"
          end

=begin

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
        current_state
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