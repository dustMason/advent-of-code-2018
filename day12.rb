PADDING = '...'

initial_state = PADDING + '##....#.#.#...#.#..#.#####.#.#.##.#.#.#######...#.##....#..##....#.#..##.####.#..........#..#...#...'

pots = initial_state.dup
patterns = DATA.read.each_line.map { |line| line.strip.split(' => ') }

GENS = 50_000_000_000
# GENS = 20

def ff(final_pots, iteration)
  total = 0
  left = GENS - iteration
  final_pots.each_char.with_index do |pot, i|
    total += (i - PADDING.size + left) if pot == '#'
  end
  puts "#{iteration} #{final_pots}"
  puts total
end

GENS.times do |g|
  puts "#{g} #{pots}"
  new_generation = pots.dup + '.'
  patterns.each do |pattern, result|
    i = pots.index(pattern)
    while i
      new_generation[i+2] = result
      i = pots.index(pattern, i + 1)
    end
  end

  # part 2

  if ('.' + pots) == new_generation
    ff(new_generation, g + 1)
    return
  end

  pots = new_generation.dup
end

# part 1

ff(pots, GENS)

__END__
..#.# => #
.#### => #
#.... => .
####. => #
...## => .
.#.#. => .
..#.. => .
##.#. => .
#.#.# => #
..... => .
#.#.. => .
....# => .
.#..# => .
###.# => #
#..#. => .
##### => .
...#. => #
#.##. => #
.#.## => #
#..## => #
.##.. => #
##.## => .
..### => .
###.. => .
##..# => #
.#... => #
.###. => #
#.### => .
.##.# => .
#...# => #
##... => .
..##. => .
