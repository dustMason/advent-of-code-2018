require 'set'
require_relative 'astar.rb'

STARTING_HP = 200
GOBLIN_POWER = 3
DEBUG = false

Target = Struct.new(:x, :y, :size)

class Being
  attr_accessor :hp, :x, :y
  def initialize(x, y)
    @hp = STARTING_HP
    @x = x
    @y = y
  end

  def char
    self.class.to_s[0]
  end
end

class Elf < Being; end
class Goblin < Being; end

def adjacent(x, y)
  [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
end

def print(beings, terrain)
  board = []
  terrain.each do |(x, y), char|
    board[y] ||= []
    board[y][x] = char
  end
  beings.each do |(x, y), being|
    board[y] ||= []
    board[y][x] = being.char
  end
  puts board.map(&:join)
  puts beings.to_a.sort_by { |_c, b| [b.y, b.x] }.map { |_c, b| b.hp }.join(", ")
  puts
end

def solve(elf_power: 3, disposable_elves: Float::INFINITY, beings:, terrain:, walls:)
  rounds = 0

  print(beings, terrain) if DEBUG

  dead_elves = 0

  result = loop do
    all_beings = beings.to_a.sort_by { |c, _| c.reverse }.reverse

    until all_beings.empty?
      _coord, being = all_beings.pop
      x, y = [being.x, being.y]

      enemy_class = being.instance_of?(Elf) ? Goblin : Elf
      enemies = beings.select { |_, b| b.is_a?(enemy_class) }
      break :success if enemies.none?

      # 0. determine target
      obstacles = (walls.keys + beings.keys).to_set

      unless (adjacent(being.x, being.y) & enemies.to_h.keys).any?
        target = enemies.map do |(ex, ey), _e|
          p = AStar.new([x, y], [ex, ey], obstacles).search
          p.shift
          p.pop
          Target.new(p.first.x, p.first.y, p.size) if p.size > 0
        end.compact.sort_by { |t| [t.size, t.y, t.x] }.first

        # 1. move
        if target
          puts "moving #{being} from #{being.x}, #{being.y} to #{target.x}, #{target.y}" if DEBUG
          being.x = target.x
          being.y = target.y
          beings[[target.x, target.y]] = being
          terrain.delete([target.x, target.y])
          beings.delete([x, y])
          terrain[[x, y]] = '.'
        end
      end

      # 2. attack
      adjacents = adjacent(being.x, being.y)
      attack_targets = adjacents.map { |ax, ay| beings[[ax, ay]] }.select { |b| b.instance_of?(enemy_class) }
      if attack_targets.any?
        attack_target = attack_targets.sort_by { |b| [b.hp, b.y, b.x] }.first
        attack_target.hp -= attack_target.is_a?(Goblin) ? elf_power : GOBLIN_POWER
        if attack_target.hp <= 0
          all_beings.reject! { |c, _b| c == [attack_target.x, attack_target.y] }
          beings.delete([attack_target.x, attack_target.y])
          terrain[[attack_target.x, attack_target.y]] = '.'
          dead_elves += 1 if attack_target.is_a?(Elf)
        end
      end
    end
    break :fail if dead_elves > disposable_elves
    break :success if beings.map { |_, b| b.class }.uniq.size == 1
    rounds += 1
    Kernel.print '.'
    puts rounds if DEBUG
    print(beings, terrain) if DEBUG
  end
  result == :success ? rounds : result
end

def parse(input)
  terrain = {}
  beings = {}
  walls = {}

  input.each_line.with_index do |line, y|
    line.strip.each_char.with_index do |char, x|
      terrain[[x, y]] = '.'
      case char
      when '#'
        terrain[[x, y]] = char
        walls[[x, y]] = char
      when 'G' then beings[[x, y]] = Goblin.new(x, y)
      when 'E' then beings[[x, y]] = Elf.new(x, y)
      end
    end
  end

  [terrain, beings, walls]
end

DATA.read.split("\n---\n").each_slice(2) do |input, expected|
  exit if input.start_with?('break')

  # part 1

  terrain, beings, walls = parse(input)
  print(beings, terrain) if DEBUG
  rounds = solve(beings: beings, terrain: terrain, walls: walls)
  hp = beings.reduce(0) { |acc, (_coord, being)| acc + being.hp }
  puts
  puts "part 1. got hp: #{hp}, rounds: #{rounds}. ans: #{hp * rounds}, expected #{expected.strip}"
  puts

  # part 2

  best_power = (3..200).bsearch do |power|
    terrain, beings, walls = parse(input)
    rounds = solve(beings: beings, terrain: terrain, walls: walls, elf_power: power, disposable_elves: 0)
    hp = beings.reduce(0) { |acc, (_coord, being)| acc + being.hp }
    Kernel.print "x" if rounds == :fail
    puts
    puts "#{power} => hp: #{hp}, rounds: #{rounds}. ans: #{hp * rounds unless rounds == :fail}"
    rounds != :fail
  end

  puts "best power: #{best_power}"
end

__END__
################################
##########..........############
########G..................#####
#######..G.GG...............####
#######....G.......#......######
########.G.G...............#E..#
#######G.................#.....#
########.......................#
########G.....G....#.....##....#
########.....#....G.........####
#########..........##....E.E#.##
##########G..G..........#####.##
##########....#####G....####E.##
######....G..#######.....#.....#
###....#....#########......#####
####........#########..E...#####
###.........#########......#####
####G....G..#########......#####
####..#.....#########....#######
######.......#######...E.#######
###.G.....E.G.#####.....########
#.....G........E.......#########
#......#..#..####....#.#########
#...#.........###.#..###########
##............###..#############
######.....E####..##############
######...........###############
#######....E....################
######...####...################
######...###....################
###.....###..##..###############
################################
---
257954
---
break
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
---
27730
---
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
---
18740
---
#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######
---
28944
---
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
---
39514
---
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
---
36334
---
#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######
---
27755
