module Brilliant
  module Detechtive
    #Bi-directionally linked node
    class Node
      attr_reader :upstream, :downstream, :name

      # @param [Node] node
      def add_upstream(node)
        if node
          @upstream << node
          node.downstream << self
        end
      end

      # @param [Node] node
      def add_downstream(node)
        if node
          @downstream << node
          node.upstream << self
        end
      end

      # @param [String] name - name of the event the node represents
      def initialize(name)
        @name = name
        @upstream = []
        @downstream = []
      end

      def to_s
        @name
      end
    end
  end
end
