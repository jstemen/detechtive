# -*- encoding: utf-8 -*-

require_relative '../../spec_helper'

module Brilliant
  module Detechtive


    describe Graph do

      before do
        @graph= Graph.new

      end

      describe '#new' do
        it 'works' do
          expect(@graph).not_to be_nil
        end
      end

      describe '#input' do
        it 'handles mergeable case' do
          input = [
              ["fight", "gunshot", "fleeing"],
              ["gunshot", "falling", "fleeing"]
          ]

          res = @graph.input(input)
          expect(res.state).to eq('Merge is possible')
          expect(res.timelines).to eq(
                                       [
                                           ["fight", "gunshot", "falling",
                                            "fleeing"]
                                       ]
                                   )

        end


        it 'handles mergeable case 2' do
          input = [
              ["shouting", "fight", "fleeing"],
              ["fight", "gunshot", "panic", "fleeing"],
              ["anger", "shouting"]
          ]

          res = @graph.input(input)
          expect(res.state).to eq('Merge is possible')
          expect(res.timelines).to eq(
                                       [["anger", "shouting", "fight", "gunshot", "panic", "fleeing"]]
                                   )

        end

        it 'handles the partial merge case' do
          input = [
              ["shadowy figure", "demands",
               "scream", "siren"],
              ["shadowy figure", "pointed gun",
               "scream"]
          ]

          res = @graph.input(input)
          expect(res.state).to eq("Partial merge is possible")
          expect(res.timelines).to eq(
                                       [
                                           ["shadowy figure", "demands",
                                            "scream", "siren"],
                                           ["shadowy figure", "pointed gun",
                                            "scream", "siren"]
                                       ]

                                   )

        end

        it 'handles the no merge possible case' do
          input = [
              ["argument", "coverup",
               "pointing"],
              ["press brief", "scandal",
               "pointing"], ["argument", "bribe"]
          ]

          res = @graph.input(input)
          expect(res.state).to eq("No merge is possible")
          expect(res.timelines).to match_array(
                                       [
                                           ["argument", "coverup", "pointing"],
                                           ["press brief", "scandal",
                                            "pointing"],
                                           ["argument", "bribe"]
                                       ]

                                   )

        end
      end

      describe '#process_event_array' do
        it 'sets names to nodes map' do
          array = %w{shout run fight}
          @graph.send(:process_event_array, array)
          nodes_map = nil
          @graph.instance_eval do
            nodes_map = @name_to_node_map
          end
          nodes_map.each { |name, node|
            expect(name).to be_a(String)
            expect(node).to be_a(Node)
          }
          expect(nodes_map.collect { |name, node| name }).to eq(array)
        end
        it 'is connected' do
          array = %w{shout run fight}
          @graph.send(:process_event_array, array)
          nodes_map = nil
          @graph.instance_eval do
            nodes_map = @name_to_node_map
          end
          count=0
          node = nodes_map[array.first]
          #binding.pry
          until node.downstream.empty?
            node = node.downstream.first
            count +=1
          end
          expect(count).to eq(nodes_map.size-1)
        end
        it 'doesn\'t create duplicate copies of nodes with the same name' do
          array = %w{shout run fight}
          2.times {
            @graph.send(:process_event_array, array)
          }
          nodes_map = nil
          @graph.instance_eval do
            nodes_map = @name_to_node_map
          end
          expect(nodes_map.size).to eq(array.size)
        end
      end

    end
  end
end
