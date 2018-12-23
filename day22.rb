depth = 3879
target = [8, 713]

require 'set'
require 'rubygems'
require 'pqueue'

# depth = 510
# target = [10, 10]

max_x = target[0] + 10
max_y = target[1] + 10

indexes = {}
types = {}
total_risk = 0

0.step(to: max_y) do |y|
  0.step(to: max_x) do |x|
    level = if (x == 0 && y == 0) || (x == target[0] && y == target[1])
              0
            elsif y == 0
              x * 16807
            elsif x == 0
              y * 48271
            else
              indexes[[x - 1, y]] * indexes[[x, y - 1]]
            end
    erosion_level = (level + depth) % 20183
    risk = erosion_level % 3
    total_risk += risk if y <= target[1] && x <= target[0]
    indexes[[x, y]] = erosion_level
    types[[x, y]] = risk
  end
end

def render(tiles, pos, target)
  board = []
  tiles.each do |(x, y), risk|
    board[y] ||= []
    board[y][x] = if pos == [x, y]
                    'X'
                  elsif target == [x, y]
                    'M'
                  else
                    %w[. = |][risk]
                  end
  end
  board
end

# part 1

puts total_risk

# part 2

ROCKY = 0
WET = 1
NARROW = 2

CLIMB = :climb
TORCH = :torch
NEITHER = :neither

Edge = Struct.new(:from, :to, :weight) do
  def <=>(other)
    self.weight <=> other.weight
  end
end

Node = Struct.new(:x, :y, :type, :tool)

class Graph
  attr_accessor :nodes, :edges, :types

  def initialize(types)
    @nodes = {}
    @edges = {}
    @types = types.dup
  end

  def build!
    @types.each do |(x, y), type|
      # make nodes for each possible tool
      tools = case type
              when ROCKY then [CLIMB, TORCH]
              when WET then [CLIMB, NEITHER]
              when NARROW then [TORCH, NEITHER]
              end
      tools.each do |tool|
        @nodes[[x, y]] ||= Set.new
        @nodes[[x, y]] << Node.new(x, y, type, tool)
      end
    end

    @nodes.each do |(x, y), set|
      expand(x, y).each do |(nx, ny)|
        set.each do |node|
          next unless passable?(nx, ny)
          @nodes[[nx, ny]]&.each do |dest|
            weight = minutes(node.tool, dest.tool)
            add_edge(node, dest, weight)
          end
        end
      end
    end

    @nodes = @nodes.flat_map do |(x, y), set|
      set.to_a.map do |node|
        [[x, y, node.tool], node]
      end
    end.to_h
  end

  def add_edge(from, to, weight)
    # puts "adding edge from #{from} to #{to} with weight #{weight}"
    edges[from] ||= Set.new
    edges[from] << Edge.new(from, to, weight)
  end

  def minutes(from_tool, to_tool)
    return 1 if from_tool == to_tool
    8
  end

  def passable?(x, y)
    return false if x < 0 || y < 0
    true
  end

  def expand(x, y)
    # x, y = [node.x, node.y]
    tiles = [
      [x, (y - 1)], # north
      [(x - 1), y], # west
      [(x + 1), y], # east
      [x, (y + 1)], # south
    ]
    # tiles.flat_map do |(px, py)|
    #   case @types[[px, py]]
    #   when ROCKY then [[px, py, CLIMB], [px, py, TORCH]]
    #   when WET then [[px, py, CLIMB], [px, py, NEITHER]]
    #   when NARROW then [[px, py, TORCH], [px, py, NEITHER]]
    #   end
    # end.compact
  end
end


class Dijkstra
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
    @path_to = {}
    @distance_to = {}
    @pq = PQueue.new { |a, b| @distance_to[a] < @distance_to[b] }

    compute_shortest_path
  end

  def shortest_path_to(node)
    path = []
    while node != @source_node
      path.unshift(node)
      node = @path_to[node]
    end
    path
  end

  private

  def compute_shortest_path
    update_distance_of_all_edges_to(Float::INFINITY)
    @distance_to[@source_node] = 0

    @pq << @source_node
    until @pq.empty?
      node = @pq.pop
      @graph.edges[node].each do |adj_edge|
        relax(adj_edge)
      end
    end
  end

  def update_distance_of_all_edges_to(distance)
    @graph.nodes.each do |_, node|
      @distance_to[node] = distance
    end
  end

  def relax(edge)
    return if @distance_to[edge.to] <= @distance_to[edge.from] + edge.weight

    @distance_to[edge.to] = @distance_to[edge.from] + edge.weight
    @path_to[edge.to] = edge.from

    # If the node is already in this priority queue, the only that happens is
    # that its distance is decreased.
    # @pq.insert(edge.to, @distance_to[edge.to])
    @pq << edge.to
  end
end

puts render(types, [0, 0], target).map(&:join)

graph = Graph.new(types)
graph.build!

from_node = graph.nodes[[0, 0, TORCH]]
to_node = graph.nodes[[*target, TORCH]]

shortest = Dijkstra.new(graph, from_node).shortest_path_to(to_node)
puts shortest.inspect

cost = 0
tool = from_node.tool
shortest.each do |node|
  cost += node.tool == tool ? 1 : 8
  tool = node.tool
end

puts cost
