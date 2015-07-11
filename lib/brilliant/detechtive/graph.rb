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

        timeline_states = heads.collect { |head|
          recursive_traverse head, TimelineState.new
        }
        final_state = timeline_states.inject{|t,s|
          t.timelines = t.timelines + s.timelines
          t
        }
        final_state


      end

      def recursive_traverse(node, current_state)
        puts "visiting #{node.name}"
        current_state.timelines.first << node.name
        if node.downstream.empty?

          puts "#{node.name} has no downstream nodes"
          return current_state
        elsif node.downstream.size == 1
          return recursive_traverse node.downstream.first, current_state
        else

          forks = node.downstream.collect { |down|
            recursive_traverse(down, TimelineState.new).timelines.first
          }
          common_elems = forks.inject { |sum, nex| sum & nex }
          #binding.pry

          common_elem = common_elems.first
          base_forks = forks.select { |f| f.first.equal? common_elem }
          if common_elem.nil?
            current_state.state = "No merge is possible"

            timelines = forks.collect { |f|
              (current_state.timelines + f).flatten
            }

            current_state.timelines = timelines


          elsif base_forks.empty?
            current_state.state = "Partial merge is possible"
            #partial merge
            jumbled = []

            com_index = forks.first.find_index common_elem
            agreed = forks.first.slice(com_index, forks.first.size - 1)

            dispute = forks.collect { |f|
              term = f.find_index common_elem
              f.slice(0, term)
            }

            versions = []
            #could iterate over permuations of parallel events here to list all possible timelines, but outside of problem description
            dispute.each { |p|
              versions << (current_state.timelines + p + agreed).flatten
            }

            current_state.timelines = versions


          elsif base_forks.size == 1
            current_state.state = "Merge is possible"
            puts "full merge possilbe"

            current_state.timelines = [(current_state.timelines + forks.sort_by(&:size).last).flatten]
          else
            raise " only one base fork should be found!"
          end

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