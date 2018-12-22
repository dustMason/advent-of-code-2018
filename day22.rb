# depth = 3879
# target = [8, 713]

require 'set'

depth = 510
target = [10, 10]

max_x = target[0] + 4
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

Node = Struct.new(:x, :y, :i, :g, :h, :f, :tool)

ROCKY = 0
WET = 1
NARROW = 2

CLIMB = :climb
TORCH = :torch
NEITHER = :neither

class PriorityQueue
  def initialize
    @queue = {}
  end

  def any?
    @queue.any?
  end

  def insert(key, value)
    @queue[key] = value
    order_queue
  end

  def remove_min
    @queue.shift.first
  end

  private

  def order_queue
    @queue.sort_by { |_key, value| value }
  end
end

class Dijkstra
  def initialize(graph, source_node)
    @graph = graph
    @source_node = source_node
    @path_to = {}
    @distance_to = {}
    @pq = PriorityQueue.new

    compute_shortest_path
  end

  def shortest_path_to(node)
    path = []
    while node != @source_node
      path.unshift(node)
      node = @path_to[node]
    end

    path.unshift(@source_node)
  end

  private

  def compute_shortest_path
    update_distance_of_all_edges_to(Float::INFINITY)
    @distance_to[@source_node] = 0

    @pq.insert(@source_node, 0)
    while @pq.any?
      node = @pq.remove_min
      node.adjacent_edges.each do |adj_edge|
        relax(adj_edge)
      end
    end
  end

  def update_distance_of_all_edges_to(distance)
    @graph.nodes.each do |node|
      @distance_to[node] = distance
    end
  end

  def relax(edge)
    return if @distance_to[edge.to] <= @distance_to[edge.from] + edge.weight

    @distance_to[edge.to] = @distance_to[edge.from] + edge.weight
    @path_to[edge.to] = edge.from

    # If the node is already in this priority queue, the only that happens is
    # that its distance is decreased.
    @pq.insert(edge.to, @distance_to[edge.to])
  end
end

# class AStar
#   def initialize(start, destination, types)
#     @start_node = Node.new(*start, -1, 0, -1, -1, TORCH)
#     @dest_node  = Node.new(*destination, -1, -1, -1, -1, TORCH)
#     @open_nodes = [] # nodes to be inspected
#     @closed_nodes = [] # node we've already inspected
#     @open_nodes
#     @types = types
#   end
#
#   def distance(node, dest)
#     (node.x - dest.x).abs + (node.y - dest.y).abs
#   end
#
#   def minutes(from_tool, to_tool)
#     return 1 if from_tool == to_tool
#     8
#   end
#
#   def passable?(x, y, tool)
#     return false if x < 0 || y < 0
#     return false if tool == NEITHER && @types[[x, y]] == ROCKY
#     return false if tool == TORCH && @types[[x, y]] == WET
#     return false if tool == CLIMB && @types[[x, y]] == NARROW
#     true
#   end
#
#   def expand(x, y)
#     # x, y = [node.x, node.y]
#     tiles = [
#       [x, (y - 1)], # north
#       [(x - 1), y], # west
#       [(x + 1), y], # east
#       [x, (y + 1)], # south
#     ]
#     tiles.flat_map do |(px, py)|
#       case @types[[px, py]]
#       when ROCKY then [[px, py, CLIMB], [px, py, TORCH]]
#       when WET then [[px, py, CLIMB], [px, py, NEITHER]]
#       when NARROW then [[px, py, TORCH], [px, py, NEITHER]]
#       end
#     end.compact
#   end
#
#   # def bfs(pos, dest, seen = Set.new, path = [])
#   #   x, y, tool, cost = pos
#   #   seen << [x, y, tool]
#   #   paths = []
#   #   expand(x, y).each do |(nx, ny, new_tool)|
#   #     next if seen.include?([nx, ny, new_tool])
#   #     next unless passable?(nx, ny, new_tool) # && !(nx == @dest_node.x && ny == @dest_node.y)
#   #     new_cost = cost + minutes(tool, new_tool)
#   #     t_path = path + [[nx, ny, new_tool, new_cost]]
#   #     paths << t_path
#   #     paths += bfs([nx, ny, new_tool, new_cost], dest, seen, t_path)
#   #   end
#   #   paths
#   # end
#
#   def search
#     while @open_nodes.any?
#       _f, best_node = @open_nodes.map.with_index.min_by { |node, _| node.f }
#
#       current_node = @open_nodes[best_node]
#
#       if current_node.x == @dest_node.x && current_node.y == @dest_node.y
#         @dest_node.g = current_node.g + cost(current_node, @dest_node)
#         path = [@dest_node]
#
#         while current_node.i != -1
#           current_node = @closed_nodes[current_node.i]
#           path.unshift(current_node)
#         end
#
#         return path
#       end
#
#       @open_nodes.delete_at(best_node)
#       @closed_nodes << current_node
#
#       expand(current_node).each do |(nx, ny, new_tool)|
#         next if !passable?(nx, ny, new_tool) && !(nx == @dest_node.x && ny == @dest_node.y)
#         next if (@closed_nodes + @open_nodes).any? { |node| node.x == nx && node.y == ny }
#
#         new_node = Node.new(nx, ny, @closed_nodes.size - 1, -1, -1, -1, new_tool)
#
#         new_node.g = current_node.g + cost(current_node, new_node)
#         new_node.h = distance(new_node, @dest_node)
#         new_node.f = new_node.g + new_node.h
#
#         @open_nodes << new_node
#       end
#     end
#     []
#   end
# end

puts render(types, [0, 0], target).map(&:join)

# pathfinder = AStar.new([0, 0], [10, 10], types)
pathfinder = AStar.new(types)
result = pathfinder.bfs([0, 0, TORCH, 0], [*target, TORCH])

puts result.select { |path| path.last[0..1] == target }.sort_by { |path| path.last.last }.first.to_s

