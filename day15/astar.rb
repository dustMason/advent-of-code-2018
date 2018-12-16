Node = Struct.new(:x, :y, :i, :g, :h, :f)

NORTH = 2
WEST = 4
EAST = 6
SOUTH = 8

class AStar
  def initialize(start, destination, obstacles)
    @start_node = Node.new(*start, -1, -1, -1, -1)
    @dest_node  = Node.new(*destination, -1, -1, -1, -1)
    @open_nodes = [] # nodes to be inspected
    @closed_nodes = [] # node we've already inspected
    @open_nodes.push(@start_node)
    @obstacles = obstacles
  end

  def distance(node, dest)
    (node.x - dest.x).abs + (node.y - dest.y).abs
  end

  def cost(node, dest)
    direction = [dest.y - node.y, dest.x - node.x]

    return NORTH if direction[0] < 0 && direction[1] == 0
    return WEST if direction[1] < 0 && direction[0] == 0
    return EAST if direction[1] > 0 && direction[0] == 0
    return SOUTH if direction[0] > 0 && direction[1] == 0

    10
  end

  def passable?(x, y)
    !@obstacles.include?([x, y])
  end

  def expand(node)
    x, y  = [node.x, node.y]
    [
      [x, (y - 1)], # north
      [(x - 1), y], # west
      [(x + 1), y], # east
      [x, (y + 1)], # south
    ]
  end

  def search
    while @open_nodes.any?
      _f, best_node = @open_nodes.map.with_index.min_by { |node, _| node.f }

      current_node = @open_nodes[best_node]

      if current_node.x == @dest_node.x && current_node.y == @dest_node.y
        path = [@dest_node]

        while current_node.i != -1
          current_node = @closed_nodes[current_node.i]
          path.unshift(current_node)
        end

        return path
      end

      @open_nodes.delete_at(best_node)
      @closed_nodes << current_node

      expand(current_node).each do |(nx, ny)|
        next if !passable?(nx, ny) && !(nx == @dest_node.x && ny == @dest_node.y)
        next if (@closed_nodes + @open_nodes).any? { |node| node.x == nx && node.y == ny }

        new_node = Node.new(nx, ny, @closed_nodes.size-1, -1, -1, -1)

        new_node.g = current_node.g + cost(current_node, new_node)
        new_node.h = distance(new_node, @dest_node)
        new_node.f = new_node.g + new_node.h

        @open_nodes << new_node
      end
    end

    []
  end
end
