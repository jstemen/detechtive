class Graph
  def initialize
    @nodes = {}
  end

  def input(array)
    array.each_with_index{|name, i|
      last = nil
      last = @nodes[array[i-1]] if i > 1
      saved = @nodes[name] || Node.new(name)
      saved.add_upstream last
      @nodes[name]=saved
    }
  end

end