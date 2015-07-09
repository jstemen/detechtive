# -*- encoding: utf-8 -*-

require_relative '../../spec_helper'

module Brilliant
  module Detechtive
    describe Graph do

      describe '#new' do
        it 'works' do
          result = Graph.new
          expect(result).not_to be_nil
        end
      end

      describe '#input' do
        it 'sets names to nodes map' do
          graph = Graph.new
          array = %w{shout run fight}
          graph.input array
          nodes_map = nil
          graph.instance_eval do
            nodes_map = @name_to_node_map
          end
          nodes_map.each{|name,node|
            expect(name).to be_a(String)
            expect(node).to be_a(Node)
          }
          expect(nodes_map.collect{|name,node| name}).to eq(array)
        end
      end

    end
  end
end
