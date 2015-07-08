class Node
  attr_reader :upstream, :downstream, :name


  def add_upstream(node)
    if node
      @upstream << node
      node.downstream << node
    end
  end

  def add_downstream(node)
    if node
      @downstream << node
      node.upstream << node
    end
  end

  def initialize(name)
    @name = name
    @upstream = []
    @downstream = []
  end
end