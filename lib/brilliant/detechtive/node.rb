module Brilliant
  module Detechtive
    class Node
      attr_reader :upstream, :downstream, :name

      def add_upstream(node)
        if node
          @upstream << node
          node.downstream << self
        end
      end

      def add_downstream(node)
        if node
          @downstream << node
          node.upstream << self
        end
      end

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
