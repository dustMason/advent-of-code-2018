require 'set'

input = DATA.read

class Device
  class << self
    attr_reader :reg

    @reg = []

    def reset(a, b, c, d)
      @reg = [a, b, c, d]
    end

    def addr(rega, regb, regc)
      @reg[regc] = @reg[rega] + @reg[regb]
    end

    def addi(rega, valb, regc)
      @reg[regc] = @reg[rega] + valb
    end

    def mulr(rega, regb, regc)
      @reg[regc] = @reg[rega] * @reg[regb]
    end

    def muli(rega, valb, regc)
      @reg[regc] = @reg[rega] * valb
    end

    def banr(rega, regb, regc)
      @reg[regc] = @reg[rega] & @reg[regb]
    end

    def bani(rega, valb, regc)
      @reg[regc] = @reg[rega] & valb
    end

    def borr(rega, regb, regc)
      @reg[regc] = @reg[rega] | @reg[regb]
    end

    def bori(rega, valb, regc)
      @reg[regc] = @reg[rega] | valb
    end

    def setr(rega, _, regc)
      @reg[regc] = @reg[rega].dup
    end

    def seti(vala, _, regc)
      @reg[regc] = vala
    end

    def gtir(vala, regb, regc)
      @reg[regc] = vala > @reg[regb] ? 1 : 0
    end

    def gtri(rega, valb, regc)
      @reg[regc] = @reg[rega] > valb ? 1 : 0
    end

    def gtrr(rega, regb, regc)
      @reg[regc] = @reg[rega] > @reg[regb] ? 1 : 0
    end

    def eqir(vala, regb, regc)
      @reg[regc] = vala == @reg[regb] ? 1 : 0
    end

    def eqri(rega, valb, regc)
      @reg[regc] = @reg[rega] == valb ? 1 : 0
    end

    def eqrr(rega, regb, regc)
      @reg[regc] = @reg[rega] == @reg[regb] ? 1 : 0
    end
  end
end

all_ops = Device.methods(false) - [:reg, :reset]

part1, part2 = input.split("\n\n\n\n")

# part 1

how_many = 0
part1.split("\n\n").each do |example|
  before, operation, after = example.lines.map(&:strip)
  before = before.scan(/\d/).map(&:to_i)
  operation = operation.split(' ').map(&:to_i)
  after = after.scan(/\d/).map(&:to_i)

  args = operation[1..-1]
  possibles = 0
  all_ops.each do |op|
    Device.reset(*before)
    Device.send(op, *args)
    expected = Device.reg
    if expected == after
      possibles += 1
      break if possibles == 3
    end
  end
  how_many += 1 if possibles == 3
end
puts how_many

# part 2

map = {}

part1.split("\n\n").each.with_index do |example, i|
  before, operation, after = example.lines.map(&:strip)
  before = before.scan(/\d/).map(&:to_i)
  operation = operation.split(' ').map(&:to_i)
  after = after.scan(/\d/).map(&:to_i)

  args = operation[1..-1]
  possibles = []
  all_ops.each do |op|
    Device.reset(*before)
    Device.send(op, *args)
    expected = Device.reg
    possibles << op if expected == after
  end

  map[operation[0]] ||= Set.new
  map[operation[0]] += possibles.to_set
end

identified = {}

until map.all? { |(_num, choices)| choices.size == 1 }
  map.keys.each do |num|
    if map[num].size == 1
      identified[num] = map[num].to_a.first
      (map.keys - [num]).each do |nnum|
        map[nnum] = map[nnum].subtract(map[num])
      end
    end
  end
end

Device.reset(0, 0, 0, 0)

part2.each_line do |line|
  instruction = line.split(' ').map(&:to_i)
  op = identified[instruction[0]]
  Device.send(op, *instruction[1..-1])
end

puts Device.reg.to_s

__END__
Before: [1, 1, 1, 0]
4 1 0 0
After:  [1, 1, 1, 0]

Before: [1, 1, 0, 1]
5 1 3 3
After:  [1, 1, 0, 1]

Before: [3, 2, 3, 1]
14 2 1 3
After:  [3, 2, 3, 2]

Before: [0, 1, 2, 1]
5 1 3 0
After:  [1, 1, 2, 1]

Before: [2, 1, 2, 3]
1 3 3 2
After:  [2, 1, 3, 3]

Before: [1, 0, 2, 0]
11 0 2 1
After:  [1, 2, 2, 0]

Before: [1, 2, 1, 1]
8 2 3 0
After:  [1, 2, 1, 1]

Before: [1, 0, 3, 2]
10 0 3 3
After:  [1, 0, 3, 3]

Before: [0, 1, 3, 1]
3 0 0 0
After:  [0, 1, 3, 1]

Before: [2, 1, 3, 2]
15 0 1 2
After:  [2, 1, 3, 2]

Before: [2, 1, 2, 1]
1 2 0 2
After:  [2, 1, 2, 1]

Before: [0, 0, 2, 0]
3 0 0 2
After:  [0, 0, 0, 0]

Before: [1, 1, 3, 2]
10 0 3 3
After:  [1, 1, 3, 3]

Before: [2, 3, 2, 3]
14 3 2 3
After:  [2, 3, 2, 2]

Before: [0, 1, 3, 2]
10 1 3 0
After:  [3, 1, 3, 2]

Before: [1, 1, 1, 0]
4 1 0 2
After:  [1, 1, 1, 0]

Before: [1, 2, 3, 2]
12 2 2 3
After:  [1, 2, 3, 2]

Before: [3, 2, 1, 1]
8 2 3 3
After:  [3, 2, 1, 1]

Before: [0, 1, 3, 2]
10 1 3 2
After:  [0, 1, 3, 2]

Before: [0, 3, 3, 0]
12 2 2 3
After:  [0, 3, 3, 2]

Before: [2, 2, 2, 0]
1 2 0 0
After:  [2, 2, 2, 0]

Before: [0, 2, 0, 3]
11 3 3 2
After:  [0, 2, 9, 3]

Before: [0, 1, 3, 2]
6 3 1 1
After:  [0, 3, 3, 2]

Before: [1, 0, 2, 0]
2 2 3 0
After:  [3, 0, 2, 0]

Before: [3, 3, 1, 1]
8 2 3 1
After:  [3, 1, 1, 1]

Before: [0, 1, 0, 2]
3 0 0 0
After:  [0, 1, 0, 2]

Before: [1, 1, 3, 2]
10 0 3 0
After:  [3, 1, 3, 2]

Before: [0, 0, 1, 1]
3 0 0 2
After:  [0, 0, 0, 1]

Before: [0, 1, 1, 2]
3 0 0 2
After:  [0, 1, 0, 2]

Before: [0, 1, 1, 1]
3 0 0 3
After:  [0, 1, 1, 0]

Before: [1, 1, 1, 1]
5 1 3 1
After:  [1, 1, 1, 1]

Before: [1, 1, 3, 3]
4 1 0 3
After:  [1, 1, 3, 1]

Before: [3, 3, 1, 1]
13 2 3 3
After:  [3, 3, 1, 3]

Before: [3, 1, 1, 3]
9 2 3 0
After:  [3, 1, 1, 3]

Before: [1, 1, 2, 0]
11 1 2 1
After:  [1, 2, 2, 0]

Before: [2, 3, 2, 2]
1 2 0 2
After:  [2, 3, 2, 2]

Before: [0, 3, 2, 3]
1 2 0 1
After:  [0, 2, 2, 3]

Before: [1, 1, 2, 0]
15 1 2 1
After:  [1, 3, 2, 0]

Before: [0, 3, 1, 3]
9 2 3 1
After:  [0, 3, 1, 3]

Before: [3, 1, 2, 0]
1 2 2 3
After:  [3, 1, 2, 2]

Before: [0, 2, 1, 3]
9 2 3 0
After:  [3, 2, 1, 3]

Before: [0, 1, 0, 1]
13 1 3 3
After:  [0, 1, 0, 3]

Before: [1, 1, 1, 2]
4 1 0 0
After:  [1, 1, 1, 2]

Before: [2, 2, 3, 1]
6 3 2 0
After:  [3, 2, 3, 1]

Before: [3, 3, 1, 2]
10 2 3 1
After:  [3, 3, 1, 2]

Before: [3, 2, 3, 3]
11 3 3 1
After:  [3, 9, 3, 3]

Before: [0, 0, 2, 3]
11 3 3 3
After:  [0, 0, 2, 9]

Before: [0, 1, 0, 0]
0 3 1 3
After:  [0, 1, 0, 1]

Before: [3, 3, 0, 3]
11 0 3 0
After:  [9, 3, 0, 3]

Before: [2, 1, 3, 1]
5 1 3 1
After:  [2, 1, 3, 1]

Before: [1, 1, 2, 3]
4 1 0 1
After:  [1, 1, 2, 3]

Before: [2, 3, 3, 3]
11 0 3 0
After:  [6, 3, 3, 3]

Before: [1, 2, 2, 1]
13 0 3 2
After:  [1, 2, 3, 1]

Before: [0, 1, 3, 2]
3 0 0 3
After:  [0, 1, 3, 0]

Before: [3, 2, 3, 2]
14 2 3 3
After:  [3, 2, 3, 2]

Before: [1, 1, 2, 2]
6 3 1 2
After:  [1, 1, 3, 2]

Before: [0, 2, 3, 2]
3 0 0 1
After:  [0, 0, 3, 2]

Before: [3, 2, 2, 3]
14 3 2 2
After:  [3, 2, 2, 3]

Before: [2, 1, 1, 2]
15 0 1 1
After:  [2, 3, 1, 2]

Before: [1, 1, 1, 3]
4 1 0 3
After:  [1, 1, 1, 1]

Before: [1, 3, 2, 3]
1 2 2 0
After:  [2, 3, 2, 3]

Before: [1, 1, 2, 1]
4 1 0 0
After:  [1, 1, 2, 1]

Before: [1, 1, 3, 1]
13 0 3 1
After:  [1, 3, 3, 1]

Before: [1, 0, 2, 1]
8 3 3 1
After:  [1, 1, 2, 1]

Before: [3, 3, 2, 1]
6 3 2 1
After:  [3, 3, 2, 1]

Before: [3, 3, 2, 3]
14 0 2 2
After:  [3, 3, 2, 3]

Before: [1, 1, 1, 1]
5 1 3 0
After:  [1, 1, 1, 1]

Before: [0, 1, 2, 0]
2 2 3 0
After:  [3, 1, 2, 0]

Before: [0, 2, 1, 3]
7 0 3 2
After:  [0, 2, 0, 3]

Before: [2, 1, 0, 0]
13 1 3 1
After:  [2, 3, 0, 0]

Before: [0, 2, 2, 1]
15 0 2 1
After:  [0, 2, 2, 1]

Before: [2, 2, 3, 0]
14 2 0 3
After:  [2, 2, 3, 2]

Before: [0, 1, 3, 1]
5 1 3 0
After:  [1, 1, 3, 1]

Before: [1, 1, 3, 1]
5 1 3 0
After:  [1, 1, 3, 1]

Before: [0, 1, 3, 1]
12 2 2 1
After:  [0, 2, 3, 1]

Before: [1, 3, 2, 1]
11 1 2 2
After:  [1, 3, 6, 1]

Before: [3, 2, 3, 0]
2 1 3 3
After:  [3, 2, 3, 3]

Before: [0, 1, 3, 1]
5 1 3 1
After:  [0, 1, 3, 1]

Before: [1, 2, 2, 2]
11 0 2 1
After:  [1, 2, 2, 2]

Before: [3, 0, 2, 1]
6 3 2 1
After:  [3, 3, 2, 1]

Before: [1, 1, 2, 0]
4 1 0 0
After:  [1, 1, 2, 0]

Before: [0, 2, 1, 0]
3 0 0 1
After:  [0, 0, 1, 0]

Before: [0, 2, 0, 0]
2 1 3 3
After:  [0, 2, 0, 3]

Before: [1, 1, 1, 0]
4 1 0 3
After:  [1, 1, 1, 1]

Before: [1, 0, 2, 2]
15 0 2 2
After:  [1, 0, 3, 2]

Before: [0, 0, 2, 1]
3 0 0 1
After:  [0, 0, 2, 1]

Before: [2, 1, 0, 3]
0 2 1 2
After:  [2, 1, 1, 3]

Before: [1, 0, 2, 0]
13 0 3 1
After:  [1, 3, 2, 0]

Before: [0, 0, 3, 3]
12 2 2 1
After:  [0, 2, 3, 3]

Before: [2, 1, 3, 1]
5 1 3 0
After:  [1, 1, 3, 1]

Before: [0, 1, 0, 3]
7 0 2 2
After:  [0, 1, 0, 3]

Before: [3, 0, 2, 0]
1 2 2 2
After:  [3, 0, 2, 0]

Before: [2, 1, 1, 1]
5 1 3 3
After:  [2, 1, 1, 1]

Before: [3, 1, 0, 2]
10 1 3 0
After:  [3, 1, 0, 2]

Before: [3, 1, 2, 0]
0 3 1 2
After:  [3, 1, 1, 0]

Before: [3, 1, 2, 1]
5 1 3 1
After:  [3, 1, 2, 1]

Before: [2, 2, 3, 1]
6 3 2 2
After:  [2, 2, 3, 1]

Before: [0, 1, 2, 1]
5 1 3 1
After:  [0, 1, 2, 1]

Before: [2, 2, 2, 3]
11 3 3 1
After:  [2, 9, 2, 3]

Before: [2, 1, 1, 2]
2 0 3 0
After:  [3, 1, 1, 2]

Before: [1, 1, 0, 2]
10 1 3 0
After:  [3, 1, 0, 2]

Before: [1, 1, 3, 1]
4 1 0 3
After:  [1, 1, 3, 1]

Before: [0, 2, 2, 1]
3 0 0 2
After:  [0, 2, 0, 1]

Before: [1, 1, 0, 2]
6 3 1 0
After:  [3, 1, 0, 2]

Before: [0, 0, 0, 3]
7 0 3 1
After:  [0, 0, 0, 3]

Before: [2, 1, 2, 2]
6 3 1 1
After:  [2, 3, 2, 2]

Before: [0, 1, 2, 1]
5 1 3 2
After:  [0, 1, 1, 1]

Before: [2, 0, 3, 3]
11 0 3 2
After:  [2, 0, 6, 3]

Before: [0, 3, 0, 0]
3 0 0 2
After:  [0, 3, 0, 0]

Before: [3, 3, 1, 2]
10 2 3 2
After:  [3, 3, 3, 2]

Before: [1, 1, 3, 0]
13 1 3 3
After:  [1, 1, 3, 3]

Before: [2, 1, 0, 1]
0 2 1 1
After:  [2, 1, 0, 1]

Before: [2, 2, 2, 1]
6 3 2 1
After:  [2, 3, 2, 1]

Before: [2, 1, 2, 0]
2 0 3 1
After:  [2, 3, 2, 0]

Before: [1, 2, 3, 3]
11 2 3 1
After:  [1, 9, 3, 3]

Before: [0, 1, 1, 0]
7 0 3 2
After:  [0, 1, 0, 0]

Before: [0, 2, 1, 1]
3 0 0 1
After:  [0, 0, 1, 1]

Before: [1, 1, 2, 3]
9 1 3 3
After:  [1, 1, 2, 3]

Before: [3, 0, 1, 3]
1 3 0 3
After:  [3, 0, 1, 3]

Before: [0, 3, 1, 2]
10 2 3 0
After:  [3, 3, 1, 2]

Before: [2, 2, 1, 3]
1 3 3 2
After:  [2, 2, 3, 3]

Before: [2, 2, 2, 1]
6 3 2 3
After:  [2, 2, 2, 3]

Before: [0, 2, 2, 2]
1 2 0 0
After:  [2, 2, 2, 2]

Before: [0, 1, 3, 2]
12 2 2 0
After:  [2, 1, 3, 2]

Before: [0, 2, 1, 0]
3 0 0 3
After:  [0, 2, 1, 0]

Before: [1, 1, 3, 1]
4 1 0 2
After:  [1, 1, 1, 1]

Before: [2, 2, 2, 1]
8 3 3 0
After:  [1, 2, 2, 1]

Before: [1, 1, 3, 1]
12 2 2 3
After:  [1, 1, 3, 2]

Before: [3, 3, 3, 1]
6 3 2 3
After:  [3, 3, 3, 3]

Before: [2, 0, 3, 2]
14 2 3 0
After:  [2, 0, 3, 2]

Before: [2, 1, 3, 2]
12 2 2 2
After:  [2, 1, 2, 2]

Before: [1, 0, 1, 1]
8 2 3 2
After:  [1, 0, 1, 1]

Before: [0, 2, 0, 2]
7 0 3 3
After:  [0, 2, 0, 0]

Before: [1, 1, 2, 3]
9 1 3 0
After:  [3, 1, 2, 3]

Before: [1, 2, 2, 1]
15 1 2 0
After:  [4, 2, 2, 1]

Before: [1, 1, 3, 3]
9 0 3 3
After:  [1, 1, 3, 3]

Before: [2, 3, 0, 3]
15 2 3 0
After:  [3, 3, 0, 3]

Before: [1, 1, 3, 3]
1 3 3 0
After:  [3, 1, 3, 3]

Before: [0, 2, 3, 2]
7 0 1 0
After:  [0, 2, 3, 2]

Before: [3, 1, 1, 0]
0 3 1 0
After:  [1, 1, 1, 0]

Before: [0, 3, 2, 0]
1 2 2 3
After:  [0, 3, 2, 2]

Before: [0, 0, 1, 1]
8 2 3 1
After:  [0, 1, 1, 1]

Before: [0, 1, 3, 0]
12 2 2 3
After:  [0, 1, 3, 2]

Before: [3, 0, 1, 2]
10 2 3 3
After:  [3, 0, 1, 3]

Before: [1, 1, 0, 0]
4 1 0 0
After:  [1, 1, 0, 0]

Before: [0, 3, 2, 3]
7 0 3 0
After:  [0, 3, 2, 3]

Before: [0, 2, 3, 0]
3 0 0 0
After:  [0, 2, 3, 0]

Before: [0, 2, 0, 3]
1 3 0 0
After:  [3, 2, 0, 3]

Before: [3, 3, 1, 2]
10 2 3 3
After:  [3, 3, 1, 3]

Before: [1, 1, 2, 2]
6 3 1 3
After:  [1, 1, 2, 3]

Before: [0, 1, 1, 2]
6 3 1 3
After:  [0, 1, 1, 3]

Before: [0, 0, 2, 3]
15 0 2 0
After:  [2, 0, 2, 3]

Before: [1, 1, 3, 2]
14 2 3 1
After:  [1, 2, 3, 2]

Before: [0, 2, 0, 1]
7 0 1 1
After:  [0, 0, 0, 1]

Before: [0, 1, 2, 1]
6 3 2 2
After:  [0, 1, 3, 1]

Before: [2, 1, 0, 0]
2 0 3 3
After:  [2, 1, 0, 3]

Before: [3, 1, 3, 1]
5 1 3 0
After:  [1, 1, 3, 1]

Before: [2, 1, 3, 1]
6 3 2 2
After:  [2, 1, 3, 1]

Before: [3, 0, 3, 1]
12 2 2 0
After:  [2, 0, 3, 1]

Before: [0, 2, 2, 3]
3 0 0 0
After:  [0, 2, 2, 3]

Before: [1, 1, 3, 2]
6 3 1 3
After:  [1, 1, 3, 3]

Before: [3, 1, 1, 2]
10 1 3 1
After:  [3, 3, 1, 2]

Before: [1, 1, 2, 3]
15 2 1 0
After:  [3, 1, 2, 3]

Before: [2, 0, 3, 3]
14 2 0 2
After:  [2, 0, 2, 3]

Before: [1, 1, 1, 2]
4 1 0 1
After:  [1, 1, 1, 2]

Before: [0, 1, 2, 0]
7 0 2 2
After:  [0, 1, 0, 0]

Before: [0, 3, 0, 3]
3 0 0 0
After:  [0, 3, 0, 3]

Before: [3, 1, 0, 0]
0 2 1 0
After:  [1, 1, 0, 0]

Before: [1, 1, 2, 0]
4 1 0 1
After:  [1, 1, 2, 0]

Before: [1, 1, 2, 0]
4 1 0 2
After:  [1, 1, 1, 0]

Before: [1, 1, 0, 2]
0 2 1 3
After:  [1, 1, 0, 1]

Before: [1, 1, 1, 2]
6 3 1 3
After:  [1, 1, 1, 3]

Before: [0, 3, 0, 2]
3 0 0 0
After:  [0, 3, 0, 2]

Before: [0, 0, 3, 2]
7 0 1 2
After:  [0, 0, 0, 2]

Before: [1, 3, 3, 2]
12 2 2 3
After:  [1, 3, 3, 2]

Before: [0, 3, 3, 2]
3 0 0 2
After:  [0, 3, 0, 2]

Before: [0, 1, 0, 3]
1 3 0 3
After:  [0, 1, 0, 3]

Before: [0, 0, 2, 3]
3 0 0 2
After:  [0, 0, 0, 3]

Before: [2, 1, 0, 2]
2 0 3 2
After:  [2, 1, 3, 2]

Before: [1, 2, 1, 3]
1 3 0 2
After:  [1, 2, 3, 3]

Before: [1, 0, 0, 3]
15 2 3 1
After:  [1, 3, 0, 3]

Before: [3, 1, 0, 3]
9 1 3 2
After:  [3, 1, 3, 3]

Before: [0, 0, 0, 0]
7 0 1 2
After:  [0, 0, 0, 0]

Before: [0, 2, 3, 0]
14 2 1 1
After:  [0, 2, 3, 0]

Before: [2, 0, 2, 1]
6 3 2 2
After:  [2, 0, 3, 1]

Before: [2, 1, 1, 1]
8 2 3 0
After:  [1, 1, 1, 1]

Before: [1, 0, 3, 3]
12 2 2 1
After:  [1, 2, 3, 3]

Before: [0, 0, 3, 1]
3 0 0 1
After:  [0, 0, 3, 1]

Before: [1, 1, 3, 1]
4 1 0 0
After:  [1, 1, 3, 1]

Before: [1, 3, 2, 1]
14 1 2 3
After:  [1, 3, 2, 2]

Before: [2, 1, 2, 3]
9 1 3 1
After:  [2, 3, 2, 3]

Before: [2, 1, 0, 0]
0 2 1 0
After:  [1, 1, 0, 0]

Before: [3, 1, 0, 1]
5 1 3 2
After:  [3, 1, 1, 1]

Before: [1, 2, 3, 3]
12 2 2 0
After:  [2, 2, 3, 3]

Before: [1, 3, 2, 1]
1 2 2 3
After:  [1, 3, 2, 2]

Before: [0, 2, 2, 3]
1 3 0 2
After:  [0, 2, 3, 3]

Before: [2, 0, 3, 1]
8 3 3 3
After:  [2, 0, 3, 1]

Before: [1, 3, 1, 2]
10 2 3 2
After:  [1, 3, 3, 2]

Before: [1, 1, 2, 1]
5 1 3 1
After:  [1, 1, 2, 1]

Before: [2, 0, 1, 3]
9 2 3 0
After:  [3, 0, 1, 3]

Before: [0, 3, 1, 0]
13 2 3 3
After:  [0, 3, 1, 3]

Before: [1, 2, 0, 1]
8 3 3 1
After:  [1, 1, 0, 1]

Before: [2, 1, 2, 3]
15 0 2 1
After:  [2, 4, 2, 3]

Before: [3, 3, 2, 3]
11 0 2 2
After:  [3, 3, 6, 3]

Before: [0, 0, 0, 2]
7 0 1 0
After:  [0, 0, 0, 2]

Before: [0, 1, 3, 1]
12 2 2 2
After:  [0, 1, 2, 1]

Before: [3, 2, 2, 3]
11 3 3 1
After:  [3, 9, 2, 3]

Before: [2, 3, 1, 0]
2 0 3 3
After:  [2, 3, 1, 3]

Before: [3, 3, 1, 2]
10 2 3 0
After:  [3, 3, 1, 2]

Before: [1, 0, 1, 0]
13 0 3 3
After:  [1, 0, 1, 3]

Before: [1, 1, 3, 3]
9 0 3 2
After:  [1, 1, 3, 3]

Before: [2, 2, 2, 2]
2 0 3 1
After:  [2, 3, 2, 2]

Before: [0, 1, 1, 3]
9 2 3 0
After:  [3, 1, 1, 3]

Before: [0, 1, 3, 1]
6 3 2 0
After:  [3, 1, 3, 1]

Before: [1, 2, 3, 3]
11 1 3 1
After:  [1, 6, 3, 3]

Before: [1, 2, 1, 3]
1 3 3 0
After:  [3, 2, 1, 3]

Before: [0, 3, 2, 0]
2 2 3 2
After:  [0, 3, 3, 0]

Before: [2, 1, 0, 1]
5 1 3 1
After:  [2, 1, 0, 1]

Before: [2, 0, 3, 0]
14 2 0 3
After:  [2, 0, 3, 2]

Before: [1, 1, 1, 3]
9 0 3 2
After:  [1, 1, 3, 3]

Before: [2, 1, 2, 1]
15 1 2 0
After:  [3, 1, 2, 1]

Before: [2, 1, 3, 1]
6 3 2 0
After:  [3, 1, 3, 1]

Before: [1, 1, 3, 2]
4 1 0 2
After:  [1, 1, 1, 2]

Before: [1, 1, 1, 0]
13 2 3 0
After:  [3, 1, 1, 0]

Before: [0, 2, 3, 0]
2 1 3 3
After:  [0, 2, 3, 3]

Before: [2, 1, 0, 3]
15 0 1 1
After:  [2, 3, 0, 3]

Before: [1, 1, 2, 0]
13 0 3 2
After:  [1, 1, 3, 0]

Before: [2, 2, 2, 2]
2 2 3 0
After:  [3, 2, 2, 2]

Before: [0, 0, 1, 0]
7 0 2 1
After:  [0, 0, 1, 0]

Before: [0, 0, 2, 3]
3 0 0 3
After:  [0, 0, 2, 0]

Before: [3, 1, 1, 3]
9 1 3 3
After:  [3, 1, 1, 3]

Before: [2, 1, 0, 3]
0 2 1 1
After:  [2, 1, 0, 3]

Before: [2, 0, 2, 2]
2 2 3 0
After:  [3, 0, 2, 2]

Before: [1, 2, 2, 3]
14 3 2 3
After:  [1, 2, 2, 2]

Before: [0, 0, 2, 3]
3 0 0 0
After:  [0, 0, 2, 3]

Before: [1, 0, 1, 0]
13 2 3 2
After:  [1, 0, 3, 0]

Before: [3, 3, 1, 1]
13 2 3 0
After:  [3, 3, 1, 1]

Before: [1, 1, 1, 3]
11 3 3 3
After:  [1, 1, 1, 9]

Before: [0, 3, 3, 3]
12 2 2 3
After:  [0, 3, 3, 2]

Before: [0, 2, 1, 3]
3 0 0 1
After:  [0, 0, 1, 3]

Before: [1, 0, 2, 3]
9 0 3 1
After:  [1, 3, 2, 3]

Before: [2, 3, 2, 1]
6 3 2 0
After:  [3, 3, 2, 1]

Before: [1, 3, 1, 3]
9 2 3 0
After:  [3, 3, 1, 3]

Before: [0, 1, 0, 0]
3 0 0 1
After:  [0, 0, 0, 0]

Before: [1, 0, 0, 0]
13 0 3 3
After:  [1, 0, 0, 3]

Before: [1, 3, 3, 2]
10 0 3 3
After:  [1, 3, 3, 3]

Before: [2, 0, 1, 2]
10 2 3 0
After:  [3, 0, 1, 2]

Before: [1, 1, 0, 1]
5 1 3 1
After:  [1, 1, 0, 1]

Before: [2, 2, 0, 0]
2 1 3 3
After:  [2, 2, 0, 3]

Before: [2, 2, 3, 2]
14 2 3 3
After:  [2, 2, 3, 2]

Before: [3, 3, 2, 3]
14 3 2 3
After:  [3, 3, 2, 2]

Before: [0, 1, 2, 2]
10 1 3 3
After:  [0, 1, 2, 3]

Before: [1, 0, 3, 2]
12 2 2 2
After:  [1, 0, 2, 2]

Before: [0, 2, 0, 2]
7 0 2 2
After:  [0, 2, 0, 2]

Before: [0, 0, 2, 0]
7 0 3 2
After:  [0, 0, 0, 0]

Before: [1, 1, 0, 0]
0 2 1 1
After:  [1, 1, 0, 0]

Before: [3, 1, 0, 1]
0 2 1 0
After:  [1, 1, 0, 1]

Before: [1, 1, 3, 1]
5 1 3 3
After:  [1, 1, 3, 1]

Before: [1, 1, 3, 3]
4 1 0 1
After:  [1, 1, 3, 3]

Before: [1, 1, 3, 0]
0 3 1 0
After:  [1, 1, 3, 0]

Before: [2, 1, 0, 3]
15 2 3 2
After:  [2, 1, 3, 3]

Before: [1, 0, 2, 2]
15 1 2 0
After:  [2, 0, 2, 2]

Before: [0, 3, 0, 1]
8 3 3 2
After:  [0, 3, 1, 1]

Before: [3, 1, 0, 1]
5 1 3 1
After:  [3, 1, 0, 1]

Before: [0, 2, 3, 2]
12 2 2 2
After:  [0, 2, 2, 2]

Before: [2, 1, 0, 3]
11 0 3 1
After:  [2, 6, 0, 3]

Before: [3, 1, 2, 0]
2 2 3 1
After:  [3, 3, 2, 0]

Before: [1, 2, 2, 1]
13 0 3 0
After:  [3, 2, 2, 1]

Before: [2, 3, 3, 2]
14 2 0 0
After:  [2, 3, 3, 2]

Before: [2, 1, 0, 0]
0 2 1 2
After:  [2, 1, 1, 0]

Before: [0, 0, 0, 1]
3 0 0 1
After:  [0, 0, 0, 1]

Before: [2, 2, 2, 3]
11 0 3 1
After:  [2, 6, 2, 3]

Before: [2, 2, 3, 0]
12 2 2 3
After:  [2, 2, 3, 2]

Before: [2, 3, 3, 1]
8 3 3 0
After:  [1, 3, 3, 1]

Before: [2, 1, 2, 2]
2 2 3 3
After:  [2, 1, 2, 3]

Before: [0, 0, 1, 1]
8 3 3 1
After:  [0, 1, 1, 1]

Before: [1, 1, 3, 1]
6 3 2 3
After:  [1, 1, 3, 3]

Before: [1, 1, 2, 2]
6 3 1 1
After:  [1, 3, 2, 2]

Before: [0, 0, 3, 2]
14 2 3 3
After:  [0, 0, 3, 2]

Before: [3, 1, 2, 2]
6 3 1 0
After:  [3, 1, 2, 2]

Before: [1, 0, 1, 2]
10 0 3 0
After:  [3, 0, 1, 2]

Before: [0, 2, 2, 0]
3 0 0 3
After:  [0, 2, 2, 0]

Before: [2, 1, 0, 0]
0 3 1 2
After:  [2, 1, 1, 0]

Before: [2, 1, 3, 2]
12 2 2 1
After:  [2, 2, 3, 2]

Before: [1, 1, 0, 2]
4 1 0 3
After:  [1, 1, 0, 1]

Before: [3, 1, 1, 1]
5 1 3 2
After:  [3, 1, 1, 1]

Before: [3, 0, 2, 0]
15 2 2 1
After:  [3, 4, 2, 0]

Before: [0, 2, 3, 1]
14 2 1 2
After:  [0, 2, 2, 1]

Before: [3, 2, 2, 3]
14 0 2 2
After:  [3, 2, 2, 3]

Before: [1, 1, 2, 1]
4 1 0 2
After:  [1, 1, 1, 1]

Before: [1, 3, 3, 1]
6 3 2 1
After:  [1, 3, 3, 1]

Before: [0, 0, 0, 0]
7 0 1 3
After:  [0, 0, 0, 0]

Before: [0, 3, 1, 3]
3 0 0 1
After:  [0, 0, 1, 3]

Before: [0, 1, 0, 0]
0 3 1 0
After:  [1, 1, 0, 0]

Before: [0, 0, 3, 1]
12 2 2 1
After:  [0, 2, 3, 1]

Before: [0, 0, 1, 1]
8 3 3 3
After:  [0, 0, 1, 1]

Before: [1, 3, 3, 1]
6 3 2 3
After:  [1, 3, 3, 3]

Before: [1, 1, 1, 3]
4 1 0 2
After:  [1, 1, 1, 3]

Before: [0, 3, 0, 2]
3 0 0 1
After:  [0, 0, 0, 2]

Before: [0, 1, 3, 1]
12 2 2 0
After:  [2, 1, 3, 1]

Before: [2, 1, 2, 1]
5 1 3 1
After:  [2, 1, 2, 1]

Before: [3, 0, 1, 2]
10 2 3 1
After:  [3, 3, 1, 2]

Before: [0, 3, 2, 3]
15 0 3 3
After:  [0, 3, 2, 3]

Before: [1, 1, 2, 2]
4 1 0 1
After:  [1, 1, 2, 2]

Before: [2, 1, 0, 2]
10 1 3 1
After:  [2, 3, 0, 2]

Before: [1, 1, 2, 2]
4 1 0 2
After:  [1, 1, 1, 2]

Before: [3, 0, 1, 3]
15 1 3 1
After:  [3, 3, 1, 3]

Before: [1, 3, 0, 1]
8 3 3 0
After:  [1, 3, 0, 1]

Before: [2, 2, 3, 2]
14 2 0 2
After:  [2, 2, 2, 2]

Before: [0, 3, 2, 1]
11 3 2 3
After:  [0, 3, 2, 2]

Before: [3, 2, 3, 2]
2 1 3 3
After:  [3, 2, 3, 3]

Before: [1, 1, 2, 3]
1 2 2 0
After:  [2, 1, 2, 3]

Before: [3, 1, 1, 0]
13 2 3 3
After:  [3, 1, 1, 3]

Before: [0, 3, 0, 2]
3 0 0 2
After:  [0, 3, 0, 2]

Before: [3, 2, 2, 3]
11 0 3 0
After:  [9, 2, 2, 3]

Before: [0, 1, 0, 3]
7 0 1 3
After:  [0, 1, 0, 0]

Before: [0, 1, 0, 2]
3 0 0 3
After:  [0, 1, 0, 0]

Before: [3, 1, 0, 3]
1 3 1 3
After:  [3, 1, 0, 3]

Before: [2, 1, 0, 0]
15 0 1 0
After:  [3, 1, 0, 0]

Before: [2, 1, 3, 0]
0 3 1 0
After:  [1, 1, 3, 0]

Before: [1, 2, 3, 1]
13 0 3 0
After:  [3, 2, 3, 1]

Before: [1, 0, 3, 1]
8 3 3 0
After:  [1, 0, 3, 1]

Before: [1, 0, 3, 1]
8 3 3 1
After:  [1, 1, 3, 1]

Before: [1, 2, 3, 1]
12 2 2 2
After:  [1, 2, 2, 1]

Before: [3, 0, 1, 1]
8 2 3 0
After:  [1, 0, 1, 1]

Before: [0, 1, 2, 2]
3 0 0 3
After:  [0, 1, 2, 0]

Before: [0, 1, 1, 3]
3 0 0 2
After:  [0, 1, 0, 3]

Before: [2, 1, 2, 1]
5 1 3 2
After:  [2, 1, 1, 1]

Before: [1, 0, 3, 3]
9 0 3 3
After:  [1, 0, 3, 3]

Before: [1, 0, 2, 3]
15 2 2 3
After:  [1, 0, 2, 4]

Before: [1, 2, 3, 2]
15 0 2 2
After:  [1, 2, 3, 2]

Before: [3, 1, 2, 3]
15 2 2 0
After:  [4, 1, 2, 3]

Before: [1, 0, 3, 2]
10 0 3 1
After:  [1, 3, 3, 2]

Before: [3, 1, 2, 3]
14 0 2 2
After:  [3, 1, 2, 3]

Before: [3, 0, 2, 2]
15 1 2 0
After:  [2, 0, 2, 2]

Before: [2, 3, 2, 3]
11 2 3 2
After:  [2, 3, 6, 3]

Before: [2, 1, 1, 0]
13 2 3 1
After:  [2, 3, 1, 0]

Before: [2, 0, 1, 2]
10 2 3 2
After:  [2, 0, 3, 2]

Before: [1, 2, 2, 1]
8 3 3 2
After:  [1, 2, 1, 1]

Before: [3, 2, 2, 1]
14 0 2 3
After:  [3, 2, 2, 2]

Before: [3, 1, 2, 2]
11 1 2 0
After:  [2, 1, 2, 2]

Before: [0, 3, 0, 3]
7 0 1 1
After:  [0, 0, 0, 3]

Before: [2, 1, 2, 0]
2 0 3 0
After:  [3, 1, 2, 0]

Before: [1, 1, 1, 2]
10 1 3 0
After:  [3, 1, 1, 2]

Before: [2, 1, 3, 3]
9 1 3 2
After:  [2, 1, 3, 3]

Before: [3, 0, 1, 3]
11 0 3 2
After:  [3, 0, 9, 3]

Before: [0, 1, 0, 1]
5 1 3 0
After:  [1, 1, 0, 1]

Before: [1, 1, 3, 1]
5 1 3 1
After:  [1, 1, 3, 1]

Before: [1, 1, 3, 1]
8 3 3 1
After:  [1, 1, 3, 1]

Before: [1, 1, 1, 2]
10 0 3 1
After:  [1, 3, 1, 2]

Before: [3, 2, 3, 1]
14 2 1 1
After:  [3, 2, 3, 1]

Before: [1, 2, 1, 1]
8 2 3 3
After:  [1, 2, 1, 1]

Before: [3, 3, 2, 1]
8 3 3 2
After:  [3, 3, 1, 1]

Before: [1, 1, 1, 2]
4 1 0 2
After:  [1, 1, 1, 2]

Before: [2, 3, 3, 1]
14 2 0 0
After:  [2, 3, 3, 1]

Before: [2, 0, 1, 3]
9 2 3 1
After:  [2, 3, 1, 3]

Before: [1, 1, 0, 1]
5 1 3 2
After:  [1, 1, 1, 1]

Before: [0, 1, 0, 2]
10 1 3 3
After:  [0, 1, 0, 3]

Before: [3, 1, 0, 1]
8 3 3 1
After:  [3, 1, 0, 1]

Before: [1, 1, 3, 2]
4 1 0 0
After:  [1, 1, 3, 2]

Before: [0, 3, 1, 0]
3 0 0 2
After:  [0, 3, 0, 0]

Before: [3, 1, 1, 0]
0 3 1 3
After:  [3, 1, 1, 1]

Before: [1, 0, 2, 2]
10 0 3 0
After:  [3, 0, 2, 2]

Before: [0, 1, 3, 1]
3 0 0 3
After:  [0, 1, 3, 0]

Before: [2, 3, 2, 0]
1 2 0 1
After:  [2, 2, 2, 0]

Before: [1, 1, 3, 0]
0 3 1 1
After:  [1, 1, 3, 0]

Before: [2, 0, 1, 3]
15 1 3 0
After:  [3, 0, 1, 3]

Before: [2, 0, 3, 1]
8 3 3 2
After:  [2, 0, 1, 1]

Before: [0, 2, 3, 2]
7 0 2 3
After:  [0, 2, 3, 0]

Before: [1, 3, 3, 3]
9 0 3 1
After:  [1, 3, 3, 3]

Before: [3, 1, 2, 3]
1 3 3 1
After:  [3, 3, 2, 3]

Before: [0, 0, 3, 0]
3 0 0 3
After:  [0, 0, 3, 0]

Before: [2, 3, 2, 3]
11 1 2 3
After:  [2, 3, 2, 6]

Before: [2, 1, 0, 1]
8 3 3 1
After:  [2, 1, 0, 1]

Before: [2, 1, 1, 0]
0 3 1 2
After:  [2, 1, 1, 0]

Before: [0, 0, 3, 2]
12 2 2 2
After:  [0, 0, 2, 2]

Before: [3, 2, 3, 3]
11 1 3 0
After:  [6, 2, 3, 3]

Before: [3, 1, 0, 0]
0 2 1 3
After:  [3, 1, 0, 1]

Before: [1, 3, 2, 3]
9 0 3 0
After:  [3, 3, 2, 3]

Before: [0, 0, 0, 0]
3 0 0 3
After:  [0, 0, 0, 0]

Before: [0, 1, 1, 2]
3 0 0 1
After:  [0, 0, 1, 2]

Before: [1, 2, 2, 2]
10 0 3 0
After:  [3, 2, 2, 2]

Before: [2, 1, 2, 0]
0 3 1 2
After:  [2, 1, 1, 0]

Before: [2, 3, 0, 3]
11 1 3 0
After:  [9, 3, 0, 3]

Before: [1, 2, 3, 1]
13 0 3 1
After:  [1, 3, 3, 1]

Before: [0, 2, 0, 3]
1 3 3 0
After:  [3, 2, 0, 3]

Before: [1, 1, 0, 3]
1 3 1 2
After:  [1, 1, 3, 3]

Before: [3, 1, 3, 0]
13 1 3 3
After:  [3, 1, 3, 3]

Before: [3, 2, 2, 2]
2 2 3 0
After:  [3, 2, 2, 2]

Before: [0, 0, 3, 1]
12 2 2 2
After:  [0, 0, 2, 1]

Before: [0, 1, 3, 1]
5 1 3 2
After:  [0, 1, 1, 1]

Before: [0, 1, 1, 1]
7 0 1 1
After:  [0, 0, 1, 1]

Before: [3, 1, 3, 0]
0 3 1 0
After:  [1, 1, 3, 0]

Before: [0, 2, 2, 3]
11 1 3 0
After:  [6, 2, 2, 3]

Before: [0, 3, 0, 3]
11 1 3 0
After:  [9, 3, 0, 3]

Before: [0, 1, 3, 1]
7 0 1 2
After:  [0, 1, 0, 1]

Before: [2, 1, 2, 3]
15 2 2 1
After:  [2, 4, 2, 3]

Before: [2, 1, 2, 3]
9 1 3 3
After:  [2, 1, 2, 3]

Before: [0, 0, 3, 0]
12 2 2 1
After:  [0, 2, 3, 0]

Before: [1, 2, 3, 3]
14 2 1 3
After:  [1, 2, 3, 2]

Before: [0, 1, 2, 0]
0 3 1 1
After:  [0, 1, 2, 0]

Before: [2, 3, 1, 2]
10 2 3 0
After:  [3, 3, 1, 2]

Before: [3, 1, 3, 1]
5 1 3 3
After:  [3, 1, 3, 1]

Before: [0, 1, 3, 3]
1 3 1 1
After:  [0, 3, 3, 3]

Before: [0, 2, 1, 3]
7 0 2 2
After:  [0, 2, 0, 3]

Before: [1, 2, 3, 3]
11 1 3 0
After:  [6, 2, 3, 3]

Before: [2, 1, 1, 0]
0 3 1 1
After:  [2, 1, 1, 0]

Before: [2, 1, 2, 2]
2 2 3 0
After:  [3, 1, 2, 2]

Before: [1, 2, 3, 3]
9 0 3 2
After:  [1, 2, 3, 3]

Before: [1, 2, 2, 0]
2 2 3 1
After:  [1, 3, 2, 0]

Before: [3, 2, 2, 0]
15 2 2 3
After:  [3, 2, 2, 4]

Before: [3, 1, 3, 1]
6 3 2 2
After:  [3, 1, 3, 1]

Before: [0, 3, 2, 2]
15 3 2 0
After:  [4, 3, 2, 2]

Before: [1, 1, 3, 2]
12 2 2 0
After:  [2, 1, 3, 2]

Before: [3, 3, 1, 1]
8 2 3 0
After:  [1, 3, 1, 1]

Before: [0, 3, 0, 2]
3 0 0 3
After:  [0, 3, 0, 0]

Before: [0, 1, 2, 1]
15 1 2 1
After:  [0, 3, 2, 1]

Before: [3, 3, 2, 1]
8 3 3 0
After:  [1, 3, 2, 1]

Before: [0, 0, 2, 1]
8 3 3 2
After:  [0, 0, 1, 1]

Before: [1, 0, 3, 1]
13 0 3 2
After:  [1, 0, 3, 1]

Before: [3, 3, 3, 3]
12 2 2 1
After:  [3, 2, 3, 3]

Before: [0, 1, 1, 0]
0 3 1 3
After:  [0, 1, 1, 1]

Before: [2, 1, 0, 1]
5 1 3 2
After:  [2, 1, 1, 1]

Before: [1, 0, 0, 1]
8 3 3 0
After:  [1, 0, 0, 1]

Before: [0, 3, 0, 2]
7 0 2 3
After:  [0, 3, 0, 0]

Before: [0, 3, 3, 3]
3 0 0 0
After:  [0, 3, 3, 3]

Before: [3, 2, 3, 1]
6 3 2 2
After:  [3, 2, 3, 1]

Before: [1, 1, 2, 0]
0 3 1 1
After:  [1, 1, 2, 0]

Before: [1, 0, 1, 1]
8 3 3 1
After:  [1, 1, 1, 1]

Before: [3, 1, 3, 2]
10 1 3 2
After:  [3, 1, 3, 2]

Before: [2, 1, 0, 0]
0 2 1 3
After:  [2, 1, 0, 1]

Before: [0, 0, 0, 2]
7 0 3 1
After:  [0, 0, 0, 2]

Before: [1, 1, 2, 2]
15 1 2 1
After:  [1, 3, 2, 2]

Before: [1, 0, 2, 3]
14 3 2 1
After:  [1, 2, 2, 3]

Before: [1, 1, 3, 3]
4 1 0 2
After:  [1, 1, 1, 3]

Before: [0, 1, 0, 2]
0 2 1 2
After:  [0, 1, 1, 2]

Before: [1, 3, 3, 1]
8 3 3 2
After:  [1, 3, 1, 1]

Before: [2, 1, 3, 3]
9 1 3 1
After:  [2, 3, 3, 3]

Before: [0, 3, 1, 2]
3 0 0 3
After:  [0, 3, 1, 0]

Before: [0, 1, 3, 3]
3 0 0 0
After:  [0, 1, 3, 3]

Before: [2, 1, 1, 1]
5 1 3 0
After:  [1, 1, 1, 1]

Before: [3, 3, 3, 2]
14 2 3 2
After:  [3, 3, 2, 2]

Before: [3, 3, 3, 3]
12 2 2 2
After:  [3, 3, 2, 3]

Before: [0, 2, 2, 2]
1 2 2 2
After:  [0, 2, 2, 2]

Before: [0, 2, 1, 0]
2 1 3 0
After:  [3, 2, 1, 0]

Before: [0, 0, 3, 1]
6 3 2 0
After:  [3, 0, 3, 1]

Before: [1, 1, 2, 2]
1 2 2 3
After:  [1, 1, 2, 2]

Before: [3, 1, 0, 0]
0 2 1 1
After:  [3, 1, 0, 0]

Before: [1, 1, 0, 3]
9 0 3 0
After:  [3, 1, 0, 3]

Before: [3, 2, 2, 2]
2 1 3 3
After:  [3, 2, 2, 3]

Before: [2, 3, 2, 2]
2 2 3 1
After:  [2, 3, 2, 2]

Before: [1, 1, 1, 1]
4 1 0 3
After:  [1, 1, 1, 1]

Before: [1, 2, 1, 3]
9 0 3 3
After:  [1, 2, 1, 3]

Before: [1, 2, 0, 1]
13 0 3 3
After:  [1, 2, 0, 3]

Before: [0, 2, 2, 3]
3 0 0 3
After:  [0, 2, 2, 0]

Before: [0, 2, 3, 2]
14 2 1 2
After:  [0, 2, 2, 2]

Before: [1, 1, 3, 0]
4 1 0 1
After:  [1, 1, 3, 0]

Before: [1, 1, 0, 2]
4 1 0 1
After:  [1, 1, 0, 2]

Before: [1, 1, 0, 3]
9 1 3 1
After:  [1, 3, 0, 3]

Before: [0, 3, 0, 3]
3 0 0 3
After:  [0, 3, 0, 0]

Before: [1, 0, 3, 0]
13 0 3 1
After:  [1, 3, 3, 0]

Before: [2, 0, 2, 0]
15 1 2 3
After:  [2, 0, 2, 2]

Before: [1, 1, 3, 2]
6 3 1 2
After:  [1, 1, 3, 2]

Before: [1, 0, 2, 3]
9 0 3 2
After:  [1, 0, 3, 3]

Before: [0, 2, 3, 0]
14 2 1 0
After:  [2, 2, 3, 0]

Before: [0, 1, 2, 3]
15 2 1 1
After:  [0, 3, 2, 3]

Before: [0, 3, 3, 1]
12 2 2 3
After:  [0, 3, 3, 2]

Before: [0, 1, 0, 0]
7 0 2 1
After:  [0, 0, 0, 0]

Before: [0, 2, 1, 1]
7 0 2 2
After:  [0, 2, 0, 1]

Before: [1, 3, 1, 0]
13 0 3 1
After:  [1, 3, 1, 0]

Before: [1, 1, 0, 3]
9 0 3 1
After:  [1, 3, 0, 3]

Before: [2, 1, 1, 3]
1 3 1 0
After:  [3, 1, 1, 3]

Before: [0, 1, 1, 3]
7 0 1 1
After:  [0, 0, 1, 3]

Before: [0, 1, 0, 1]
5 1 3 1
After:  [0, 1, 0, 1]

Before: [0, 3, 2, 0]
3 0 0 0
After:  [0, 3, 2, 0]

Before: [3, 1, 3, 2]
10 1 3 0
After:  [3, 1, 3, 2]

Before: [3, 1, 2, 2]
6 3 1 2
After:  [3, 1, 3, 2]

Before: [1, 1, 2, 1]
5 1 3 0
After:  [1, 1, 2, 1]

Before: [0, 1, 0, 0]
3 0 0 0
After:  [0, 1, 0, 0]

Before: [2, 3, 0, 3]
11 0 3 2
After:  [2, 3, 6, 3]

Before: [0, 1, 2, 0]
7 0 2 1
After:  [0, 0, 2, 0]

Before: [3, 1, 2, 1]
5 1 3 3
After:  [3, 1, 2, 1]

Before: [1, 1, 0, 3]
0 2 1 2
After:  [1, 1, 1, 3]

Before: [3, 1, 1, 1]
8 3 3 0
After:  [1, 1, 1, 1]

Before: [2, 1, 3, 1]
8 3 3 1
After:  [2, 1, 3, 1]

Before: [1, 0, 3, 2]
10 0 3 2
After:  [1, 0, 3, 2]

Before: [1, 1, 1, 2]
4 1 0 3
After:  [1, 1, 1, 1]

Before: [3, 3, 3, 2]
12 2 2 3
After:  [3, 3, 3, 2]

Before: [2, 2, 3, 1]
6 3 2 1
After:  [2, 3, 3, 1]

Before: [2, 3, 2, 1]
11 1 2 1
After:  [2, 6, 2, 1]

Before: [1, 1, 3, 0]
0 3 1 3
After:  [1, 1, 3, 1]

Before: [1, 3, 1, 1]
8 3 3 1
After:  [1, 1, 1, 1]

Before: [2, 3, 1, 3]
9 2 3 2
After:  [2, 3, 3, 3]

Before: [3, 0, 2, 1]
6 3 2 0
After:  [3, 0, 2, 1]

Before: [0, 1, 3, 0]
3 0 0 3
After:  [0, 1, 3, 0]

Before: [1, 0, 2, 1]
6 3 2 2
After:  [1, 0, 3, 1]

Before: [0, 1, 0, 1]
7 0 2 2
After:  [0, 1, 0, 1]

Before: [0, 1, 3, 1]
13 1 3 1
After:  [0, 3, 3, 1]

Before: [0, 1, 0, 1]
5 1 3 3
After:  [0, 1, 0, 1]

Before: [1, 1, 1, 3]
9 1 3 2
After:  [1, 1, 3, 3]

Before: [0, 0, 0, 0]
3 0 0 2
After:  [0, 0, 0, 0]

Before: [0, 2, 0, 1]
3 0 0 0
After:  [0, 2, 0, 1]

Before: [3, 1, 0, 3]
0 2 1 0
After:  [1, 1, 0, 3]

Before: [2, 0, 2, 0]
2 0 3 1
After:  [2, 3, 2, 0]

Before: [2, 1, 1, 3]
9 2 3 3
After:  [2, 1, 1, 3]

Before: [0, 1, 0, 3]
15 0 3 3
After:  [0, 1, 0, 3]

Before: [2, 0, 2, 1]
15 1 2 3
After:  [2, 0, 2, 2]

Before: [2, 1, 1, 3]
9 1 3 3
After:  [2, 1, 1, 3]

Before: [1, 2, 1, 0]
13 2 3 3
After:  [1, 2, 1, 3]

Before: [0, 1, 0, 3]
9 1 3 1
After:  [0, 3, 0, 3]

Before: [0, 3, 2, 1]
3 0 0 2
After:  [0, 3, 0, 1]

Before: [1, 2, 3, 3]
11 1 3 3
After:  [1, 2, 3, 6]

Before: [1, 1, 0, 3]
4 1 0 3
After:  [1, 1, 0, 1]

Before: [1, 0, 0, 3]
9 0 3 3
After:  [1, 0, 0, 3]

Before: [1, 3, 1, 1]
13 0 3 2
After:  [1, 3, 3, 1]

Before: [1, 1, 0, 1]
0 2 1 1
After:  [1, 1, 0, 1]

Before: [1, 1, 0, 2]
4 1 0 2
After:  [1, 1, 1, 2]

Before: [0, 1, 3, 2]
15 1 2 1
After:  [0, 3, 3, 2]

Before: [1, 1, 3, 2]
12 2 2 2
After:  [1, 1, 2, 2]

Before: [3, 1, 3, 2]
6 3 1 1
After:  [3, 3, 3, 2]

Before: [0, 1, 0, 3]
9 1 3 3
After:  [0, 1, 0, 3]

Before: [1, 0, 1, 2]
10 2 3 1
After:  [1, 3, 1, 2]

Before: [2, 1, 2, 2]
10 1 3 1
After:  [2, 3, 2, 2]

Before: [3, 1, 2, 1]
5 1 3 2
After:  [3, 1, 1, 1]

Before: [3, 1, 0, 2]
0 2 1 0
After:  [1, 1, 0, 2]

Before: [2, 1, 3, 1]
12 2 2 3
After:  [2, 1, 3, 2]

Before: [1, 0, 1, 1]
13 2 3 2
After:  [1, 0, 3, 1]

Before: [2, 1, 1, 3]
9 2 3 0
After:  [3, 1, 1, 3]

Before: [1, 1, 2, 0]
0 3 1 3
After:  [1, 1, 2, 1]

Before: [0, 2, 2, 0]
2 2 3 3
After:  [0, 2, 2, 3]

Before: [0, 2, 2, 0]
7 0 1 2
After:  [0, 2, 0, 0]

Before: [1, 2, 3, 3]
11 3 3 0
After:  [9, 2, 3, 3]

Before: [0, 2, 3, 1]
8 3 3 0
After:  [1, 2, 3, 1]

Before: [3, 2, 2, 0]
2 1 3 2
After:  [3, 2, 3, 0]

Before: [3, 1, 3, 1]
13 1 3 0
After:  [3, 1, 3, 1]

Before: [1, 2, 1, 1]
13 2 3 2
After:  [1, 2, 3, 1]

Before: [3, 1, 0, 1]
5 1 3 0
After:  [1, 1, 0, 1]

Before: [1, 0, 1, 3]
9 2 3 2
After:  [1, 0, 3, 3]

Before: [3, 1, 1, 2]
10 2 3 1
After:  [3, 3, 1, 2]

Before: [3, 1, 3, 1]
5 1 3 1
After:  [3, 1, 3, 1]

Before: [2, 1, 1, 0]
13 1 3 3
After:  [2, 1, 1, 3]

Before: [1, 1, 0, 2]
0 2 1 1
After:  [1, 1, 0, 2]

Before: [1, 2, 3, 2]
10 0 3 1
After:  [1, 3, 3, 2]

Before: [1, 0, 1, 3]
1 3 0 0
After:  [3, 0, 1, 3]

Before: [0, 2, 0, 3]
3 0 0 0
After:  [0, 2, 0, 3]

Before: [2, 1, 3, 2]
10 1 3 0
After:  [3, 1, 3, 2]

Before: [1, 1, 2, 3]
1 3 0 0
After:  [3, 1, 2, 3]

Before: [0, 0, 1, 1]
13 2 3 0
After:  [3, 0, 1, 1]

Before: [2, 2, 1, 2]
2 1 3 1
After:  [2, 3, 1, 2]

Before: [0, 3, 3, 2]
12 2 2 3
After:  [0, 3, 3, 2]

Before: [0, 0, 2, 3]
14 3 2 2
After:  [0, 0, 2, 3]

Before: [2, 0, 1, 0]
2 0 3 0
After:  [3, 0, 1, 0]

Before: [1, 1, 1, 2]
10 0 3 3
After:  [1, 1, 1, 3]

Before: [2, 3, 2, 1]
1 2 2 1
After:  [2, 2, 2, 1]

Before: [0, 3, 0, 3]
1 3 1 3
After:  [0, 3, 0, 3]

Before: [1, 2, 3, 3]
14 2 1 0
After:  [2, 2, 3, 3]

Before: [3, 1, 0, 1]
0 2 1 3
After:  [3, 1, 0, 1]

Before: [1, 0, 1, 2]
10 0 3 1
After:  [1, 3, 1, 2]

Before: [3, 3, 2, 3]
1 3 0 2
After:  [3, 3, 3, 3]

Before: [3, 0, 3, 3]
11 3 3 3
After:  [3, 0, 3, 9]

Before: [2, 0, 2, 3]
14 3 2 0
After:  [2, 0, 2, 3]

Before: [3, 3, 2, 3]
11 3 3 2
After:  [3, 3, 9, 3]

Before: [2, 0, 3, 2]
12 2 2 2
After:  [2, 0, 2, 2]

Before: [0, 1, 1, 3]
9 2 3 2
After:  [0, 1, 3, 3]

Before: [1, 2, 1, 1]
8 2 3 2
After:  [1, 2, 1, 1]

Before: [1, 3, 3, 0]
12 2 2 0
After:  [2, 3, 3, 0]

Before: [2, 2, 3, 1]
14 2 1 0
After:  [2, 2, 3, 1]

Before: [1, 3, 2, 0]
2 2 3 3
After:  [1, 3, 2, 3]

Before: [1, 2, 0, 1]
13 0 3 1
After:  [1, 3, 0, 1]

Before: [1, 1, 3, 3]
4 1 0 0
After:  [1, 1, 3, 3]

Before: [1, 1, 3, 2]
15 0 2 2
After:  [1, 1, 3, 2]

Before: [2, 1, 2, 1]
5 1 3 3
After:  [2, 1, 2, 1]

Before: [3, 0, 3, 3]
15 1 3 1
After:  [3, 3, 3, 3]

Before: [3, 0, 3, 3]
11 0 3 1
After:  [3, 9, 3, 3]

Before: [3, 3, 2, 3]
14 0 2 0
After:  [2, 3, 2, 3]

Before: [1, 1, 3, 1]
6 3 2 0
After:  [3, 1, 3, 1]

Before: [2, 0, 2, 2]
2 2 3 3
After:  [2, 0, 2, 3]

Before: [0, 2, 0, 3]
15 2 3 3
After:  [0, 2, 0, 3]

Before: [1, 3, 2, 0]
11 1 2 3
After:  [1, 3, 2, 6]

Before: [1, 1, 0, 0]
0 2 1 2
After:  [1, 1, 1, 0]

Before: [1, 2, 0, 1]
8 3 3 2
After:  [1, 2, 1, 1]

Before: [0, 3, 2, 1]
1 2 2 1
After:  [0, 2, 2, 1]

Before: [2, 0, 0, 3]
1 3 3 0
After:  [3, 0, 0, 3]

Before: [3, 2, 3, 1]
12 2 2 0
After:  [2, 2, 3, 1]

Before: [0, 1, 0, 2]
6 3 1 3
After:  [0, 1, 0, 3]

Before: [3, 2, 2, 0]
14 0 2 3
After:  [3, 2, 2, 2]

Before: [2, 1, 3, 3]
11 2 3 3
After:  [2, 1, 3, 9]

Before: [2, 2, 1, 3]
9 2 3 2
After:  [2, 2, 3, 3]

Before: [3, 0, 0, 1]
8 3 3 2
After:  [3, 0, 1, 1]

Before: [1, 2, 1, 0]
2 1 3 3
After:  [1, 2, 1, 3]

Before: [1, 3, 3, 3]
12 2 2 3
After:  [1, 3, 3, 2]

Before: [0, 1, 1, 1]
5 1 3 2
After:  [0, 1, 1, 1]

Before: [1, 0, 0, 1]
8 3 3 3
After:  [1, 0, 0, 1]

Before: [1, 1, 2, 1]
5 1 3 2
After:  [1, 1, 1, 1]

Before: [2, 2, 2, 3]
15 2 2 0
After:  [4, 2, 2, 3]

Before: [2, 2, 2, 1]
8 3 3 2
After:  [2, 2, 1, 1]

Before: [3, 0, 2, 3]
11 0 3 0
After:  [9, 0, 2, 3]

Before: [3, 0, 3, 1]
6 3 2 1
After:  [3, 3, 3, 1]

Before: [3, 0, 3, 3]
1 3 1 1
After:  [3, 3, 3, 3]

Before: [0, 1, 0, 1]
0 2 1 1
After:  [0, 1, 0, 1]

Before: [2, 1, 0, 1]
5 1 3 3
After:  [2, 1, 0, 1]

Before: [1, 0, 1, 3]
1 3 0 2
After:  [1, 0, 3, 3]

Before: [2, 0, 2, 1]
15 1 2 2
After:  [2, 0, 2, 1]

Before: [0, 0, 2, 2]
7 0 1 0
After:  [0, 0, 2, 2]

Before: [2, 1, 1, 2]
10 1 3 2
After:  [2, 1, 3, 2]

Before: [2, 3, 2, 3]
11 3 3 2
After:  [2, 3, 9, 3]

Before: [0, 3, 3, 2]
7 0 3 0
After:  [0, 3, 3, 2]

Before: [3, 1, 3, 0]
0 3 1 2
After:  [3, 1, 1, 0]

Before: [1, 0, 1, 3]
9 0 3 0
After:  [3, 0, 1, 3]

Before: [2, 1, 2, 2]
1 2 0 1
After:  [2, 2, 2, 2]

Before: [3, 1, 0, 3]
0 2 1 1
After:  [3, 1, 0, 3]

Before: [2, 1, 3, 2]
6 3 1 2
After:  [2, 1, 3, 2]

Before: [0, 0, 1, 3]
9 2 3 1
After:  [0, 3, 1, 3]

Before: [2, 2, 2, 2]
2 1 3 0
After:  [3, 2, 2, 2]

Before: [3, 1, 1, 1]
5 1 3 3
After:  [3, 1, 1, 1]

Before: [1, 1, 2, 1]
11 0 2 3
After:  [1, 1, 2, 2]

Before: [1, 0, 2, 3]
15 0 2 2
After:  [1, 0, 3, 3]

Before: [1, 3, 3, 1]
13 0 3 3
After:  [1, 3, 3, 3]

Before: [2, 1, 3, 2]
6 3 1 0
After:  [3, 1, 3, 2]

Before: [0, 1, 1, 2]
6 3 1 2
After:  [0, 1, 3, 2]

Before: [3, 1, 2, 2]
11 0 2 2
After:  [3, 1, 6, 2]

Before: [2, 3, 2, 0]
2 2 3 1
After:  [2, 3, 2, 0]

Before: [3, 1, 1, 0]
13 1 3 3
After:  [3, 1, 1, 3]

Before: [2, 0, 2, 3]
11 3 3 1
After:  [2, 9, 2, 3]

Before: [1, 3, 3, 1]
12 2 2 1
After:  [1, 2, 3, 1]

Before: [0, 0, 0, 1]
3 0 0 3
After:  [0, 0, 0, 0]

Before: [1, 1, 0, 1]
5 1 3 0
After:  [1, 1, 0, 1]

Before: [1, 1, 0, 3]
4 1 0 0
After:  [1, 1, 0, 3]

Before: [2, 3, 2, 0]
15 0 2 2
After:  [2, 3, 4, 0]

Before: [2, 1, 0, 1]
5 1 3 0
After:  [1, 1, 0, 1]

Before: [1, 2, 3, 3]
1 3 0 0
After:  [3, 2, 3, 3]

Before: [3, 1, 1, 1]
5 1 3 0
After:  [1, 1, 1, 1]

Before: [1, 2, 1, 3]
11 1 3 2
After:  [1, 2, 6, 3]

Before: [1, 1, 0, 2]
10 0 3 2
After:  [1, 1, 3, 2]

Before: [2, 2, 0, 3]
11 1 3 3
After:  [2, 2, 0, 6]

Before: [2, 2, 0, 2]
2 0 3 2
After:  [2, 2, 3, 2]

Before: [1, 1, 2, 1]
8 3 3 2
After:  [1, 1, 1, 1]

Before: [1, 0, 1, 3]
9 2 3 1
After:  [1, 3, 1, 3]

Before: [2, 0, 2, 3]
11 0 3 2
After:  [2, 0, 6, 3]

Before: [1, 1, 2, 0]
13 1 3 1
After:  [1, 3, 2, 0]

Before: [1, 1, 3, 0]
4 1 0 2
After:  [1, 1, 1, 0]

Before: [3, 2, 3, 1]
12 2 2 1
After:  [3, 2, 3, 1]

Before: [0, 2, 3, 3]
7 0 2 1
After:  [0, 0, 3, 3]

Before: [3, 1, 2, 1]
15 2 1 3
After:  [3, 1, 2, 3]

Before: [1, 3, 1, 1]
8 3 3 3
After:  [1, 3, 1, 1]

Before: [1, 1, 0, 1]
4 1 0 3
After:  [1, 1, 0, 1]

Before: [0, 1, 0, 0]
15 0 1 0
After:  [1, 1, 0, 0]

Before: [3, 0, 2, 2]
1 2 2 0
After:  [2, 0, 2, 2]

Before: [0, 0, 2, 0]
3 0 0 0
After:  [0, 0, 2, 0]

Before: [3, 0, 2, 1]
6 3 2 2
After:  [3, 0, 3, 1]

Before: [1, 3, 2, 3]
1 3 3 3
After:  [1, 3, 2, 3]

Before: [1, 1, 2, 1]
4 1 0 3
After:  [1, 1, 2, 1]

Before: [0, 2, 3, 3]
11 2 3 2
After:  [0, 2, 9, 3]

Before: [0, 2, 3, 2]
3 0 0 2
After:  [0, 2, 0, 2]

Before: [1, 0, 2, 1]
11 0 2 3
After:  [1, 0, 2, 2]

Before: [3, 2, 1, 0]
13 2 3 2
After:  [3, 2, 3, 0]

Before: [3, 2, 1, 3]
11 0 3 3
After:  [3, 2, 1, 9]

Before: [3, 0, 2, 3]
11 3 2 2
After:  [3, 0, 6, 3]

Before: [0, 1, 3, 3]
9 1 3 0
After:  [3, 1, 3, 3]

Before: [1, 0, 3, 3]
9 0 3 2
After:  [1, 0, 3, 3]

Before: [2, 1, 2, 0]
0 3 1 3
After:  [2, 1, 2, 1]

Before: [0, 0, 3, 1]
8 3 3 3
After:  [0, 0, 3, 1]

Before: [1, 1, 2, 1]
8 3 3 3
After:  [1, 1, 2, 1]

Before: [1, 2, 2, 3]
11 0 2 3
After:  [1, 2, 2, 2]

Before: [3, 3, 3, 3]
1 3 1 1
After:  [3, 3, 3, 3]

Before: [0, 1, 2, 3]
9 1 3 0
After:  [3, 1, 2, 3]

Before: [1, 1, 0, 3]
1 3 3 0
After:  [3, 1, 0, 3]

Before: [2, 2, 3, 1]
6 3 2 3
After:  [2, 2, 3, 3]

Before: [1, 3, 3, 1]
8 3 3 0
After:  [1, 3, 3, 1]

Before: [0, 2, 3, 1]
7 0 3 0
After:  [0, 2, 3, 1]

Before: [0, 1, 2, 1]
5 1 3 3
After:  [0, 1, 2, 1]

Before: [3, 1, 1, 2]
6 3 1 0
After:  [3, 1, 1, 2]

Before: [1, 1, 2, 1]
5 1 3 3
After:  [1, 1, 2, 1]

Before: [0, 2, 0, 3]
7 0 1 3
After:  [0, 2, 0, 0]

Before: [3, 1, 1, 0]
0 3 1 2
After:  [3, 1, 1, 0]

Before: [3, 1, 0, 1]
5 1 3 3
After:  [3, 1, 0, 1]

Before: [1, 1, 1, 1]
8 2 3 3
After:  [1, 1, 1, 1]

Before: [0, 3, 2, 1]
6 3 2 2
After:  [0, 3, 3, 1]

Before: [0, 2, 1, 3]
3 0 0 3
After:  [0, 2, 1, 0]

Before: [3, 1, 3, 1]
6 3 2 1
After:  [3, 3, 3, 1]

Before: [3, 2, 2, 3]
1 3 0 3
After:  [3, 2, 2, 3]

Before: [3, 2, 1, 1]
8 3 3 2
After:  [3, 2, 1, 1]

Before: [3, 1, 1, 3]
1 3 1 2
After:  [3, 1, 3, 3]

Before: [2, 3, 3, 1]
12 2 2 1
After:  [2, 2, 3, 1]

Before: [3, 1, 3, 0]
0 3 1 1
After:  [3, 1, 3, 0]

Before: [2, 1, 2, 2]
10 1 3 0
After:  [3, 1, 2, 2]

Before: [1, 1, 3, 2]
4 1 0 3
After:  [1, 1, 3, 1]

Before: [0, 1, 0, 0]
7 0 1 3
After:  [0, 1, 0, 0]

Before: [0, 1, 1, 0]
0 3 1 1
After:  [0, 1, 1, 0]

Before: [0, 1, 0, 1]
5 1 3 2
After:  [0, 1, 1, 1]

Before: [2, 1, 1, 1]
5 1 3 1
After:  [2, 1, 1, 1]

Before: [3, 0, 2, 3]
11 0 3 3
After:  [3, 0, 2, 9]

Before: [3, 1, 0, 2]
10 1 3 2
After:  [3, 1, 3, 2]

Before: [1, 2, 2, 3]
9 0 3 2
After:  [1, 2, 3, 3]

Before: [0, 3, 2, 1]
14 1 2 3
After:  [0, 3, 2, 2]

Before: [1, 3, 0, 3]
11 3 3 2
After:  [1, 3, 9, 3]

Before: [0, 0, 2, 1]
6 3 2 2
After:  [0, 0, 3, 1]

Before: [1, 1, 2, 1]
4 1 0 1
After:  [1, 1, 2, 1]

Before: [1, 3, 2, 3]
11 1 2 0
After:  [6, 3, 2, 3]

Before: [2, 2, 1, 0]
2 0 3 3
After:  [2, 2, 1, 3]

Before: [0, 1, 1, 0]
0 3 1 0
After:  [1, 1, 1, 0]

Before: [0, 1, 2, 2]
6 3 1 0
After:  [3, 1, 2, 2]

Before: [1, 3, 3, 2]
15 0 2 0
After:  [3, 3, 3, 2]

Before: [3, 2, 3, 2]
14 2 1 2
After:  [3, 2, 2, 2]

Before: [1, 1, 0, 0]
4 1 0 1
After:  [1, 1, 0, 0]

Before: [0, 1, 3, 0]
0 3 1 0
After:  [1, 1, 3, 0]

Before: [3, 0, 3, 2]
12 2 2 2
After:  [3, 0, 2, 2]

Before: [0, 0, 2, 1]
15 2 2 0
After:  [4, 0, 2, 1]

Before: [3, 3, 0, 1]
8 3 3 0
After:  [1, 3, 0, 1]

Before: [2, 2, 1, 3]
9 2 3 3
After:  [2, 2, 1, 3]

Before: [0, 3, 1, 0]
7 0 1 2
After:  [0, 3, 0, 0]

Before: [1, 3, 2, 2]
14 1 2 2
After:  [1, 3, 2, 2]

Before: [3, 3, 2, 0]
1 2 2 0
After:  [2, 3, 2, 0]

Before: [1, 1, 3, 2]
4 1 0 1
After:  [1, 1, 3, 2]

Before: [1, 0, 2, 2]
1 2 2 0
After:  [2, 0, 2, 2]

Before: [1, 2, 0, 0]
2 1 3 3
After:  [1, 2, 0, 3]

Before: [2, 2, 2, 2]
1 2 0 0
After:  [2, 2, 2, 2]

Before: [0, 3, 2, 2]
1 2 2 2
After:  [0, 3, 2, 2]

Before: [0, 2, 3, 1]
8 3 3 2
After:  [0, 2, 1, 1]

Before: [2, 0, 3, 2]
14 2 0 1
After:  [2, 2, 3, 2]

Before: [1, 1, 1, 3]
4 1 0 1
After:  [1, 1, 1, 3]

Before: [1, 1, 3, 2]
6 3 1 1
After:  [1, 3, 3, 2]

Before: [0, 0, 3, 3]
1 3 1 1
After:  [0, 3, 3, 3]

Before: [3, 1, 3, 2]
6 3 1 0
After:  [3, 1, 3, 2]

Before: [2, 3, 3, 2]
14 2 0 3
After:  [2, 3, 3, 2]

Before: [2, 0, 1, 2]
10 2 3 3
After:  [2, 0, 1, 3]

Before: [2, 1, 2, 3]
1 3 3 0
After:  [3, 1, 2, 3]

Before: [0, 1, 1, 2]
10 2 3 0
After:  [3, 1, 1, 2]

Before: [3, 3, 2, 2]
2 2 3 1
After:  [3, 3, 2, 2]

Before: [1, 1, 0, 2]
4 1 0 0
After:  [1, 1, 0, 2]

Before: [3, 2, 2, 1]
14 0 2 0
After:  [2, 2, 2, 1]

Before: [0, 2, 3, 1]
7 0 1 2
After:  [0, 2, 0, 1]

Before: [1, 1, 2, 3]
11 3 2 2
After:  [1, 1, 6, 3]

Before: [1, 2, 2, 3]
9 0 3 3
After:  [1, 2, 2, 3]

Before: [2, 1, 3, 3]
9 1 3 3
After:  [2, 1, 3, 3]

Before: [0, 1, 3, 1]
5 1 3 3
After:  [0, 1, 3, 1]

Before: [0, 0, 2, 3]
7 0 1 1
After:  [0, 0, 2, 3]

Before: [0, 0, 2, 1]
7 0 2 0
After:  [0, 0, 2, 1]

Before: [0, 1, 0, 3]
1 3 1 1
After:  [0, 3, 0, 3]

Before: [3, 2, 3, 3]
14 2 1 3
After:  [3, 2, 3, 2]

Before: [1, 1, 0, 3]
4 1 0 1
After:  [1, 1, 0, 3]

Before: [0, 1, 1, 1]
5 1 3 3
After:  [0, 1, 1, 1]

Before: [3, 1, 3, 1]
8 3 3 2
After:  [3, 1, 1, 1]

Before: [1, 1, 1, 0]
4 1 0 1
After:  [1, 1, 1, 0]

Before: [1, 2, 2, 3]
15 0 2 0
After:  [3, 2, 2, 3]

Before: [3, 0, 2, 3]
1 3 1 3
After:  [3, 0, 2, 3]

Before: [0, 2, 0, 3]
3 0 0 2
After:  [0, 2, 0, 3]

Before: [2, 3, 0, 3]
15 2 3 2
After:  [2, 3, 3, 3]

Before: [1, 1, 1, 1]
5 1 3 2
After:  [1, 1, 1, 1]

Before: [1, 1, 1, 1]
13 2 3 1
After:  [1, 3, 1, 1]

Before: [2, 2, 2, 1]
15 2 2 3
After:  [2, 2, 2, 4]

Before: [0, 1, 3, 0]
12 2 2 1
After:  [0, 2, 3, 0]

Before: [1, 2, 1, 2]
10 0 3 0
After:  [3, 2, 1, 2]

Before: [1, 0, 3, 1]
12 2 2 0
After:  [2, 0, 3, 1]

Before: [3, 2, 0, 3]
15 2 3 1
After:  [3, 3, 0, 3]

Before: [0, 2, 2, 1]
8 3 3 1
After:  [0, 1, 2, 1]

Before: [2, 2, 1, 3]
9 2 3 1
After:  [2, 3, 1, 3]

Before: [0, 0, 2, 2]
15 2 2 1
After:  [0, 4, 2, 2]

Before: [3, 1, 1, 1]
5 1 3 1
After:  [3, 1, 1, 1]

Before: [1, 1, 3, 1]
5 1 3 2
After:  [1, 1, 1, 1]

Before: [0, 1, 1, 3]
15 0 1 3
After:  [0, 1, 1, 1]

Before: [2, 1, 2, 0]
1 2 0 1
After:  [2, 2, 2, 0]

Before: [0, 1, 1, 0]
3 0 0 1
After:  [0, 0, 1, 0]

Before: [1, 1, 1, 3]
9 2 3 1
After:  [1, 3, 1, 3]

Before: [3, 2, 1, 3]
1 3 3 2
After:  [3, 2, 3, 3]

Before: [0, 1, 2, 3]
7 0 1 1
After:  [0, 0, 2, 3]

Before: [1, 2, 0, 3]
9 0 3 3
After:  [1, 2, 0, 3]

Before: [1, 1, 1, 1]
8 2 3 2
After:  [1, 1, 1, 1]

Before: [0, 0, 1, 1]
13 2 3 2
After:  [0, 0, 3, 1]

Before: [2, 2, 3, 3]
14 2 1 0
After:  [2, 2, 3, 3]

Before: [3, 2, 0, 3]
11 0 3 1
After:  [3, 9, 0, 3]

Before: [0, 1, 1, 2]
10 2 3 2
After:  [0, 1, 3, 2]

Before: [0, 3, 0, 3]
3 0 0 2
After:  [0, 3, 0, 3]

Before: [1, 3, 3, 0]
13 0 3 1
After:  [1, 3, 3, 0]

Before: [1, 3, 1, 1]
13 2 3 1
After:  [1, 3, 1, 1]

Before: [1, 1, 0, 3]
0 2 1 1
After:  [1, 1, 0, 3]

Before: [2, 1, 3, 1]
5 1 3 2
After:  [2, 1, 1, 1]

Before: [0, 1, 0, 3]
1 3 1 0
After:  [3, 1, 0, 3]

Before: [3, 2, 3, 2]
2 1 3 2
After:  [3, 2, 3, 2]

Before: [0, 1, 3, 3]
11 3 3 3
After:  [0, 1, 3, 9]

Before: [1, 1, 0, 2]
6 3 1 1
After:  [1, 3, 0, 2]

Before: [1, 1, 3, 1]
4 1 0 1
After:  [1, 1, 3, 1]

Before: [2, 1, 0, 2]
6 3 1 0
After:  [3, 1, 0, 2]

Before: [0, 0, 2, 3]
1 3 0 2
After:  [0, 0, 3, 3]

Before: [1, 2, 2, 0]
2 2 3 3
After:  [1, 2, 2, 3]

Before: [1, 1, 1, 1]
5 1 3 3
After:  [1, 1, 1, 1]

Before: [3, 2, 2, 0]
14 0 2 2
After:  [3, 2, 2, 0]

Before: [1, 2, 1, 2]
10 2 3 3
After:  [1, 2, 1, 3]

Before: [0, 1, 1, 1]
5 1 3 1
After:  [0, 1, 1, 1]

Before: [3, 2, 2, 0]
15 3 2 3
After:  [3, 2, 2, 2]

Before: [3, 0, 2, 0]
11 0 2 2
After:  [3, 0, 6, 0]

Before: [1, 0, 0, 1]
13 0 3 1
After:  [1, 3, 0, 1]

Before: [0, 1, 3, 3]
9 1 3 3
After:  [0, 1, 3, 3]

Before: [0, 0, 2, 3]
11 2 3 0
After:  [6, 0, 2, 3]

Before: [3, 3, 3, 3]
1 3 0 1
After:  [3, 3, 3, 3]

Before: [2, 3, 1, 0]
13 2 3 3
After:  [2, 3, 1, 3]



6 1 3 1
6 2 3 2
6 1 2 0
1 0 2 1
13 1 3 1
10 1 3 3
6 1 2 2
6 1 1 1
10 1 0 0
13 0 1 0
10 0 3 3
1 3 2 1
6 3 2 2
6 3 0 0
6 3 1 3
12 0 2 3
13 3 3 3
10 1 3 1
1 1 1 0
6 0 3 1
13 0 0 2
15 2 0 2
6 0 3 3
6 3 2 2
13 2 1 2
13 2 3 2
10 0 2 0
1 0 2 3
13 0 0 0
15 0 2 0
6 3 1 1
6 3 3 2
7 0 2 2
13 2 2 2
10 3 2 3
1 3 2 0
6 2 2 1
6 2 0 2
6 0 0 3
0 3 2 1
13 1 3 1
13 1 1 1
10 0 1 0
1 0 3 3
13 3 0 2
15 2 3 2
13 0 0 0
15 0 3 0
6 0 0 1
12 0 2 1
13 1 3 1
10 1 3 3
1 3 2 1
6 2 1 2
6 0 3 3
6 1 0 0
1 0 2 0
13 0 1 0
13 0 1 0
10 0 1 1
6 3 2 0
13 1 0 3
15 3 1 3
9 2 0 3
13 3 1 3
13 3 2 3
10 1 3 1
1 1 0 2
13 1 0 0
15 0 1 0
6 3 3 1
6 2 3 3
15 0 1 0
13 0 3 0
10 0 2 2
1 2 1 1
6 0 0 0
6 3 2 2
6 2 0 2
13 2 1 2
13 2 3 2
10 2 1 1
6 1 2 2
6 2 0 0
8 0 3 0
13 0 2 0
10 0 1 1
6 3 3 2
6 2 2 0
8 0 3 3
13 3 2 3
10 1 3 1
1 1 3 0
6 3 3 1
6 1 3 3
13 3 2 1
13 1 3 1
10 0 1 0
1 0 2 1
13 1 0 2
15 2 2 2
6 1 1 0
6 3 2 3
1 0 2 0
13 0 3 0
10 1 0 1
1 1 2 3
6 3 2 1
6 2 1 0
6 3 0 2
7 0 2 0
13 0 3 0
10 0 3 3
1 3 0 2
6 2 2 0
13 0 0 3
15 3 2 3
13 1 0 1
15 1 1 1
8 0 3 1
13 1 1 1
10 2 1 2
1 2 0 1
13 2 0 3
15 3 0 3
13 3 0 0
15 0 1 0
6 3 0 2
5 3 2 2
13 2 1 2
13 2 3 2
10 1 2 1
6 3 2 3
13 1 0 0
15 0 2 0
6 3 0 2
14 3 0 2
13 2 2 2
13 2 3 2
10 1 2 1
1 1 2 2
6 2 0 1
6 2 3 3
6 3 0 3
13 3 2 3
10 3 2 2
1 2 2 3
6 2 0 2
13 3 0 1
15 1 3 1
14 1 0 0
13 0 2 0
10 0 3 3
1 3 1 1
6 0 3 3
6 3 2 0
6 0 0 2
7 2 0 3
13 3 1 3
10 1 3 1
6 2 1 3
12 0 2 0
13 0 1 0
10 1 0 1
1 1 2 3
6 2 1 2
6 1 3 0
13 0 0 1
15 1 0 1
1 0 2 2
13 2 3 2
13 2 2 2
10 3 2 3
6 3 1 2
15 0 1 2
13 2 2 2
13 2 1 2
10 3 2 3
1 3 1 0
6 1 0 1
13 3 0 3
15 3 1 3
13 3 0 2
15 2 0 2
13 1 2 1
13 1 2 1
10 0 1 0
1 0 2 1
13 2 0 2
15 2 3 2
6 2 0 3
6 2 3 0
8 0 3 0
13 0 3 0
13 0 1 0
10 1 0 1
13 0 0 2
15 2 2 2
6 1 3 0
1 0 2 3
13 3 2 3
13 3 2 3
10 3 1 1
6 0 1 0
6 0 3 3
0 3 2 0
13 0 2 0
13 0 1 0
10 0 1 1
6 2 1 0
6 2 2 3
8 0 3 0
13 0 1 0
13 0 2 0
10 0 1 1
1 1 3 3
6 3 3 2
13 1 0 0
15 0 1 0
6 2 1 1
9 1 2 0
13 0 1 0
10 0 3 3
1 3 1 2
6 2 1 0
13 1 0 1
15 1 0 1
6 3 1 3
14 3 0 3
13 3 2 3
10 3 2 2
1 2 1 0
13 0 0 3
15 3 2 3
6 1 3 1
6 3 0 2
11 1 3 1
13 1 1 1
10 0 1 0
6 1 3 2
6 0 0 3
6 3 2 1
12 1 2 1
13 1 2 1
10 1 0 0
6 3 1 1
6 1 2 3
6 2 2 2
15 3 1 3
13 3 3 3
13 3 3 3
10 3 0 0
1 0 0 1
6 0 3 0
6 2 1 3
2 2 3 2
13 2 3 2
13 2 2 2
10 1 2 1
1 1 2 0
6 2 3 2
6 0 1 3
6 3 3 1
0 3 2 2
13 2 2 2
13 2 3 2
10 0 2 0
1 0 2 1
6 3 0 0
6 2 2 3
6 0 3 2
7 2 0 0
13 0 3 0
13 0 2 0
10 0 1 1
13 1 0 0
15 0 1 0
6 3 0 2
11 0 3 2
13 2 1 2
13 2 1 2
10 2 1 1
1 1 2 2
6 0 1 1
6 3 1 3
15 0 1 3
13 3 3 3
13 3 3 3
10 3 2 2
1 2 0 3
6 2 0 1
13 1 0 0
15 0 3 0
13 0 0 2
15 2 2 2
4 2 0 0
13 0 2 0
13 0 2 0
10 0 3 3
1 3 1 1
6 1 2 3
13 3 0 0
15 0 1 0
1 0 2 2
13 2 2 2
10 2 1 1
6 3 2 2
6 3 2 0
6 3 0 3
12 3 2 0
13 0 1 0
13 0 2 0
10 1 0 1
1 1 1 0
6 0 1 2
6 2 2 3
6 0 1 1
5 2 3 2
13 2 3 2
10 0 2 0
1 0 2 2
13 0 0 1
15 1 1 1
6 1 2 0
11 0 3 3
13 3 3 3
13 3 3 3
10 2 3 2
1 2 0 0
6 3 3 1
6 3 3 2
6 2 1 3
14 1 3 2
13 2 1 2
10 0 2 0
1 0 0 3
6 1 2 1
6 3 1 2
13 1 0 0
15 0 0 0
13 1 2 2
13 2 3 2
10 3 2 3
1 3 0 1
6 1 2 3
6 2 2 0
6 0 2 2
3 0 3 0
13 0 2 0
13 0 3 0
10 0 1 1
1 1 3 3
6 2 2 0
13 3 0 1
15 1 1 1
11 1 0 2
13 2 3 2
10 2 3 3
1 3 0 2
6 0 2 0
13 2 0 3
15 3 3 3
13 2 0 1
15 1 2 1
14 3 1 3
13 3 3 3
13 3 2 3
10 2 3 2
1 2 0 0
6 0 3 3
6 3 1 1
6 2 0 2
2 2 3 2
13 2 2 2
10 2 0 0
1 0 2 1
6 3 2 0
13 0 0 2
15 2 2 2
0 3 2 0
13 0 1 0
10 0 1 1
1 1 0 3
6 0 2 1
6 0 0 2
6 1 3 0
10 0 0 1
13 1 2 1
10 1 3 3
6 0 1 1
13 0 0 0
15 0 3 0
7 2 0 0
13 0 2 0
10 0 3 3
1 3 2 1
6 2 2 0
6 0 0 3
6 3 1 2
7 0 2 3
13 3 2 3
13 3 1 3
10 3 1 1
6 2 0 3
13 1 0 2
15 2 2 2
6 1 3 0
1 0 2 0
13 0 1 0
13 0 1 0
10 0 1 1
1 1 0 2
13 1 0 0
15 0 2 0
6 3 2 3
6 3 0 1
14 3 0 1
13 1 3 1
10 1 2 2
1 2 0 1
6 2 1 3
6 1 1 2
8 0 3 2
13 2 1 2
10 2 1 1
6 2 1 2
6 3 3 0
6 3 3 3
4 2 0 2
13 2 1 2
10 1 2 1
1 1 1 2
6 1 0 3
6 2 3 1
9 1 0 1
13 1 2 1
10 2 1 2
6 1 3 1
6 2 3 3
6 2 1 0
2 0 3 3
13 3 3 3
10 2 3 2
1 2 1 1
6 3 2 0
6 2 0 2
13 3 0 3
15 3 3 3
9 2 0 0
13 0 2 0
10 0 1 1
1 1 2 2
6 2 2 0
6 0 1 3
6 3 2 1
14 1 0 0
13 0 1 0
10 2 0 2
13 2 0 0
15 0 1 0
13 0 0 1
15 1 2 1
2 1 3 0
13 0 3 0
10 2 0 2
6 3 2 1
6 2 2 0
6 2 3 3
14 1 0 0
13 0 3 0
13 0 3 0
10 0 2 2
1 2 1 0
13 2 0 2
15 2 2 2
6 0 2 3
0 3 2 1
13 1 3 1
10 0 1 0
1 0 3 3
6 0 1 1
6 1 1 0
1 0 2 0
13 0 3 0
10 0 3 3
1 3 3 0
6 1 0 3
6 1 0 1
6 3 2 2
13 1 2 1
13 1 1 1
10 1 0 0
1 0 0 1
6 0 2 0
6 1 1 2
6 2 3 3
6 2 0 0
13 0 1 0
13 0 2 0
10 1 0 1
1 1 1 0
6 1 2 1
6 3 0 2
13 2 0 3
15 3 0 3
13 1 2 1
13 1 3 1
13 1 1 1
10 0 1 0
1 0 3 1
6 3 3 0
12 0 2 0
13 0 3 0
13 0 2 0
10 0 1 1
1 1 0 3
6 3 1 1
6 2 0 0
7 0 2 1
13 1 2 1
10 1 3 3
6 1 0 2
13 2 0 0
15 0 1 0
6 0 1 1
15 0 1 0
13 0 2 0
13 0 3 0
10 0 3 3
1 3 3 1
6 0 2 2
6 1 1 0
6 0 0 3
10 0 0 2
13 2 3 2
10 1 2 1
1 1 2 3
6 3 0 2
6 0 1 1
15 0 1 0
13 0 3 0
10 0 3 3
1 3 3 1
13 3 0 0
15 0 2 0
13 0 0 3
15 3 1 3
6 2 1 2
3 0 3 2
13 2 2 2
13 2 2 2
10 1 2 1
6 1 1 0
13 0 0 3
15 3 0 3
6 3 2 2
5 3 2 3
13 3 1 3
13 3 2 3
10 1 3 1
6 1 0 2
6 2 1 0
6 1 1 3
3 0 3 3
13 3 1 3
10 1 3 1
6 0 2 3
6 2 2 2
6 1 2 0
0 3 2 0
13 0 2 0
10 1 0 1
1 1 3 0
6 2 1 1
0 3 2 3
13 3 2 3
10 0 3 0
1 0 2 1
6 2 3 0
6 0 0 3
0 3 2 2
13 2 3 2
10 2 1 1
1 1 0 2
6 1 3 1
6 3 1 0
13 0 1 0
10 0 2 2
1 2 3 1
6 3 1 2
6 2 3 3
6 2 0 0
9 0 2 0
13 0 1 0
10 0 1 1
1 1 1 3
6 3 2 0
13 1 0 2
15 2 0 2
13 0 0 1
15 1 1 1
7 2 0 2
13 2 1 2
13 2 1 2
10 2 3 3
6 3 1 1
13 0 0 0
15 0 2 0
6 0 1 2
12 1 2 2
13 2 2 2
10 3 2 3
1 3 2 1
6 1 2 2
6 1 3 0
6 2 0 3
10 0 0 2
13 2 1 2
13 2 1 2
10 2 1 1
6 1 1 3
13 1 0 0
15 0 2 0
13 1 0 2
15 2 2 2
11 3 0 0
13 0 3 0
13 0 2 0
10 1 0 1
13 3 0 2
15 2 0 2
6 3 2 0
6 3 3 3
12 0 2 2
13 2 2 2
13 2 1 2
10 2 1 1
1 1 3 2
6 2 3 3
6 2 2 1
2 1 3 3
13 3 2 3
10 2 3 2
1 2 2 3
6 1 3 1
6 2 1 2
6 1 1 0
1 0 2 2
13 2 1 2
10 3 2 3
6 3 0 0
6 3 3 1
6 3 0 2
12 1 2 1
13 1 2 1
10 3 1 3
6 0 1 0
6 2 2 1
9 1 2 1
13 1 3 1
10 1 3 3
1 3 0 1
6 0 2 3
13 2 0 2
15 2 0 2
6 3 0 0
12 0 2 3
13 3 2 3
13 3 2 3
10 3 1 1
1 1 1 3
6 3 3 1
7 2 0 1
13 1 1 1
13 1 3 1
10 1 3 3
1 3 2 0
6 0 2 3
6 1 0 1
13 1 2 2
13 2 2 2
10 2 0 0
6 1 3 3
6 3 2 1
6 3 3 2
13 3 2 3
13 3 3 3
10 0 3 0
1 0 0 1
13 3 0 3
15 3 0 3
13 0 0 2
15 2 2 2
6 2 2 0
0 3 2 3
13 3 2 3
10 3 1 1
1 1 1 0
6 1 1 3
13 3 0 2
15 2 3 2
6 3 2 1
13 3 2 2
13 2 3 2
10 2 0 0
1 0 1 1
6 3 2 3
6 1 3 2
6 0 0 0
12 3 2 3
13 3 1 3
10 1 3 1
1 1 1 3
13 0 0 1
15 1 1 1
6 2 1 2
6 1 3 0
1 0 2 0
13 0 2 0
10 0 3 3
1 3 3 0
6 0 3 3
6 3 1 1
4 2 1 1
13 1 1 1
10 1 0 0
1 0 0 3
6 2 1 1
6 3 2 0
13 2 0 2
15 2 0 2
7 2 0 0
13 0 3 0
13 0 1 0
10 0 3 3
1 3 2 1
6 0 1 0
6 0 3 3
6 2 1 2
0 3 2 3
13 3 2 3
10 1 3 1
6 1 2 3
6 3 1 0
4 2 0 0
13 0 1 0
13 0 1 0
10 0 1 1
1 1 0 3
6 2 0 0
6 3 1 2
13 1 0 1
15 1 0 1
9 0 2 0
13 0 2 0
10 3 0 3
1 3 0 2
13 3 0 0
15 0 2 0
6 1 1 3
15 3 1 0
13 0 1 0
10 2 0 2
1 2 3 0
6 2 1 3
6 0 0 2
6 1 1 1
11 1 3 2
13 2 2 2
10 0 2 0
1 0 3 2
6 0 2 0
6 0 0 3
6 3 1 0
13 0 2 0
10 0 2 2
1 2 3 3
6 3 0 2
13 0 0 0
15 0 2 0
7 0 2 0
13 0 1 0
13 0 3 0
10 3 0 3
1 3 3 2
6 1 0 0
6 2 2 3
11 1 3 3
13 3 3 3
10 3 2 2
1 2 3 1
6 1 1 3
13 0 0 0
15 0 2 0
6 2 3 2
3 0 3 0
13 0 3 0
10 0 1 1
13 2 0 3
15 3 2 3
6 3 3 0
6 0 1 2
5 2 3 0
13 0 2 0
10 1 0 1
1 1 1 3
6 3 1 2
6 3 0 1
6 2 1 0
4 0 1 2
13 2 1 2
10 3 2 3
1 3 2 0
6 0 3 2
6 0 1 1
6 2 2 3
5 2 3 1
13 1 3 1
10 1 0 0
1 0 3 1
13 1 0 2
15 2 1 2
6 2 0 0
13 3 0 3
15 3 3 3
14 3 0 3
13 3 3 3
13 3 3 3
10 1 3 1
1 1 0 2
6 1 0 3
6 1 2 1
3 0 3 1
13 1 3 1
10 1 2 2
1 2 0 1
6 3 1 2
6 0 0 3
5 3 2 2
13 2 1 2
10 1 2 1
1 1 2 0
13 1 0 1
15 1 2 1
6 2 3 2
0 3 2 2
13 2 3 2
10 0 2 0
1 0 1 1
13 3 0 0
15 0 1 0
6 2 2 2
6 1 3 3
1 0 2 0
13 0 1 0
10 1 0 1
1 1 0 3
6 2 2 1
13 1 0 0
15 0 3 0
6 1 1 2
6 2 0 1
13 1 1 1
10 3 1 3
1 3 3 0
6 3 1 2
6 1 0 1
6 2 3 3
13 1 2 3
13 3 2 3
13 3 3 3
10 3 0 0
1 0 3 1
6 1 0 0
6 3 3 3
6 1 1 2
12 3 2 0
13 0 1 0
13 0 2 0
10 0 1 1
1 1 2 2
6 3 0 0
13 0 0 1
15 1 2 1
6 1 1 3
9 1 0 3
13 3 1 3
10 2 3 2
1 2 2 0
6 0 2 2
6 0 0 1
6 1 1 3
10 3 3 1
13 1 2 1
10 0 1 0
1 0 0 1
6 1 1 0
6 2 0 2
6 3 1 3
1 0 2 3
13 3 2 3
10 3 1 1
1 1 2 0
13 3 0 1
15 1 3 1
6 1 0 3
13 1 0 2
15 2 3 2
15 3 1 2
13 2 3 2
10 2 0 0
1 0 2 2
6 1 3 0
10 0 0 1
13 1 2 1
10 2 1 2
1 2 2 1
13 0 0 2
15 2 3 2
6 3 3 0
13 3 2 0
13 0 3 0
10 1 0 1
1 1 0 0
6 0 3 3
13 1 0 1
15 1 0 1
5 3 2 1
13 1 2 1
10 0 1 0
1 0 0 2
13 1 0 1
15 1 2 1
13 1 0 3
15 3 3 3
6 2 1 0
14 3 1 0
13 0 3 0
10 0 2 2
1 2 0 0