# -*- encoding: utf-8 -*-

require_relative '../../spec_helper'

module Brilliant
  module Detechtive
    describe Node do
      before do
        @node_cat = Node.new('cat')
        @node_dog = Node.new('dog')
      end

      describe '#add_upstream' do
        it 'adds a downstream dependency on other node' do
          @node_cat.add_upstream(@node_dog)
          expect(@node_cat.upstream).to include(@node_dog)
          expect(@node_dog.downstream).to include(@node_cat)
        end
      end

      describe '#add_downstream' do
        it 'adds an upstream dependency on other node' do
          @node_cat.add_downstream(@node_dog)
          expect(@node_cat.downstream.collect(&:name)).to include(@node_dog.name)
          expect(@node_dog.upstream).to include(@node_cat)
        end
      end

      describe '#new' do
        it 'sets the name' do
          name = 'foobar'
          result = Node.new(name)
          expect(result.name).to be(name)
        end
      end

    end
  end
end
