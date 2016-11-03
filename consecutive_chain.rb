class TreeNode
  attr_reader :children, :value

  def initialize(value)
    @value = value
    @children = []
  end

  def add_child(child_node)
    @children << child_node
  end

  def height
    return 1 if children.empty?

    children.map(&:height).max + 1
  end
end

class Tree < TreeNode
end

class LongestChainConstructor
  attr_reader :matrix

  def initialize(matrix)
    @matrix = matrix
  end

  def longest_consecutive_chain
    deepest_leaf_path(tallest_tree)
  end

  private

  def deepest_leaf_path(tree)
    return [tree.value] if tree.children.empty?

    child_path = tree.children.map do |child|
      deepest_leaf_path(child)
    end.max_by(&:size)

    [tree.value].concat(child_path)
  end

  def tallest_tree
    all_trees.max_by(&:height)
  end

  # Brute force create all possible incrementing paths.
  # The deepest leaf contains our longest chain.
  def all_trees
    return @all_trees if @all_trees

    @all_trees = []
    matrix.size.times do |x|
      matrix[0].size.times do |y|
        @all_trees << build_incrementing_tree(x, y)
      end
    end

    @all_trees
  end

  def build_incrementing_tree(x, y)
    val = matrix[x][y]
    next_coords = [
      [x - 1, y],
      [x + 1, y],
      [x, y - 1],
      [x, y + 1]
    ]

    next_consecutive_coords = []
    next_coords.each do |i, j|
      next_consecutive_coords << [i, j] if consecutive?(val, i, j)
    end

    tree = Tree.new(val)
    next_consecutive_coords.each do |i, j|
      tree.add_child(build_incrementing_tree(i, j))
    end

    tree
  end

  def consecutive?(val, x, y)
    x >= 0 &&
      y >= 0 &&
      x < matrix.size &&
      y < matrix[x].size &&
      matrix[x][y] == val + 1
  end
end

def success
  'Y'
end

def failed(result, expected)
  "N, expected #{expected}, got #{result}"
end

def verify(input, expected)
  chain_constructor = LongestChainConstructor.new(input)
  result = chain_constructor.longest_consecutive_chain

  if result == expected
    success
  else
    failed(result, expected)
  end
end

puts verify([[1, 2], [1, 2]], [1, 2])
puts verify([[1, 2, 3], [4, 5, 7]], [1, 2, 3])
puts verify([[1, 3, 2], [4, 5, 6]], [4, 5, 6])
