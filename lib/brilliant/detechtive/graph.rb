module Brilliant
  module Detechtive
    # Houses a set of doubly linked nodes representing a series of events
    class Graph

      def initialize
        @name_to_node_map = {}
      end


      # @param [Array[Array[String]]] arry_of_arrays - Array of array of event names to process
      # @return [TimelineState] - contains the merge result and a list of possible timelines
      def input(arry_of_arrays)
        arry_of_arrays.each { |a|
          process_event_array a
        }

        heads = @name_to_node_map.values.select { |n| n.upstream.empty? }

        timeline_states = heads.collect { |head|
          recursive_traverse head, TimelineState.new
        }
        final_state = timeline_states.inject { |t, s|
          t.timelines = t.timelines + s.timelines
          t
        }
        final_state
      end

      private

      # Finds the the most complete sequence of events possible
      # @param [Node] node - The current node being processed in the graph
      # @param [TimelineState] current_state - Holds the timeline state based off of processed nodes so far
      # @return [TimelineState] - Holds the timeline state based off of processed nodes so far
      def recursive_traverse(node, current_state)
        Log.debug "visiting #{node.name}"
        current_state.timelines.first << node.name
        if node.downstream.empty?
          Log.debug "#{node.name} has no downstream nodes. Reached end of timeline"
          return current_state
        elsif node.downstream.size == 1
          Log.debug "#{node.name} only one downstream node.  Moving to it now."
          return recursive_traverse node.downstream.first, current_state
        else
          Log.debug "#{node.name} has #{node.downstream.size} downstream nodes.  Investigating merge options."

          timeline_forks = node.downstream.collect { |down|
            downstream_fork_states = recursive_traverse(down, TimelineState.new).timelines
            raise "Downstream partial merge detected.  This type of merge is not yet supported" unless downstream_fork_states.size == 1
            downstream_fork_states.first
          }
          common_elems = timeline_forks.inject { |sum, nex| sum & nex }

          common_elem = common_elems.first
          base_forks = timeline_forks.select { |f| f.first.equal? common_elem }
          if common_elem.nil?
            current_state.state = 'No merge is possible'

            timelines = timeline_forks.collect { |f|
              (current_state.timelines + f).flatten
            }

            current_state.timelines = timelines

          elsif base_forks.empty?
            current_state.state = 'Partial merge is possible'

            common_elem_index = timeline_forks.first.find_index common_elem
            agreed_tail_arry = timeline_forks.first.slice(common_elem_index, timeline_forks.first.size - 1)

            disputed_events_array = timeline_forks.collect { |f|
              term = f.find_index common_elem
              f.slice(0, term)
            }

            # could iterate over permuations of parallel events here to list all possible timelines, but outside of problem description
            possible_timelines = disputed_events_array.collect { |p|
              (current_state.timelines + p + agreed_tail_arry).flatten
            }

            current_state.timelines = possible_timelines

          elsif base_forks.size == 1
            current_state.state = 'Merge is possible'
            Log.debug 'Full merge possilbe'

            longest_merge_array = timeline_forks.sort_by(&:size).last
            current_state.timelines = [(current_state.timelines + longest_merge_array).flatten]
          else
            raise 'Only one base fork should be found!'
          end

        end
        current_state
      end


      # Loads events into graph in node form
      # @param [Array[String]] event_array - Array of Strings of event names
      def process_event_array(event_array)
        last = nil
        event_array.each_with_index { |name, i|
          last = @name_to_node_map[event_array[i-1]] if i > 0
          saved = @name_to_node_map[name] || Node.new(name)
          saved.add_upstream last
          @name_to_node_map[name]=saved
        }
      end

    end
  end
end