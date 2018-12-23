depth = 3879
target = [8, 713]

require 'set'
require 'rubygems'
require 'pqueue'

# example input. should output 45 for cost and 114 for risk
# depth = 510
# target = [10, 10]

max_x = target[0] + 60
max_y = target[1] + 4

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

def render(tiles, pos, target, path = nil)
  board = []
  if path
    path_hash = {}
    path.each do |node|
      path_hash[node.y] ||= []
      path_hash[node.y][node.x] = node
    end
  end
  tiles.each do |(x, y), risk|
    board[y] ||= []
    board[y][x] = if pos == [x, y]
                    'X'
                  elsif target == [x, y]
                    'M'
                  elsif path && path_hash[y] && path_hash[y][x]
                    case path_hash[y][x].tool
                    when CLIMB then 'C'
                    when TORCH then 'T'
                    when NEITHER then 'N'
                    end
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

Node = Struct.new(:x, :y, :type, :tool)
Edge = Struct.new(:from, :to, :weight)

class Graph
  attr_accessor :nodes, :edges, :types

  def initialize(types)
    @nodes = {}
    @edges = {}
    @types = types.dup
  end

  def build!
    @types.each do |(x, y), type|
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
            add_edge(node, dest, minutes(node.tool, dest.tool))
          end
        end
      end
    end

    @nodes = @nodes.flat_map do |(x, y), set|
      set.to_a.map { |node| [[x, y, node.tool], node] }
    end.to_h
  end

  def add_edge(from, to, weight)
    @edges[from] ||= Set.new
    @edges[from] << Edge.new(from, to, weight)
  end

  def minutes(from_tool, to_tool)
    from_tool == to_tool ? 1 : 8
  end

  def passable?(x, y)
    x >= 0 && y >= 0
  end

  def expand(x, y)
    [
      [x, (y - 1)], # north
      [(x - 1), y], # west
      [(x + 1), y], # east
      [x, (y + 1)], # south
    ]
  end
end

class Dijkstra
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
    @path_to = {}
    @distance_to = Hash.new { Float::INFINITY }
    @pq = PQueue.new { |a, b| @distance_to[a] < @distance_to[b] }
    @distance_to[@source_node] = 0
    @pq << @source_node
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
    until @pq.empty?
      node = @pq.pop
      @graph.edges[node].each { |edge| relax(edge) }
    end
  end

  def relax(edge)
    return if @distance_to[edge.to] <= @distance_to[edge.from] + edge.weight

    @distance_to[edge.to] = @distance_to[edge.from] + edge.weight
    @path_to[edge.to] = edge.from

    @pq << edge.to
  end
end

graph = Graph.new(types)
graph.build!

from_node = graph.nodes[[0, 0, TORCH]]
to_node = graph.nodes[[*target, TORCH]]

shortest = Dijkstra.new(graph, from_node).shortest_path_to(to_node)

puts render(types, [0, 0], target, shortest).map(&:join)

cost = 0
tool = from_node.tool
shortest.each do |node|
  cost += node.tool == tool ? 1 : 8
  tool = node.tool
end

puts cost

# guessed 1009 and 1002, both too high
# try 981
