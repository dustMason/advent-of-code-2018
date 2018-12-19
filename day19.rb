require 'set'

input = DATA.read

class Device
  class << self
    attr_reader :reg

    def reset(*regs)
      @reg = regs
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

Device.reset(0, 0, 0, 0, 0, 0)

program = input.each_line.map do |line|
  op, *args = line.split(' ')
  op.gsub!('#', '')
  [op, *args.map(&:to_i)]
end

ip_location = program.shift.last
line_number = Device.reg[ip_location]

# part 1

while (0...program.size).cover?(line_number)
  line = program[line_number]
  Device.reg[ip_location] = line_number
  Device.send(*line)
  line_number = Device.reg[ip_location] + 1
end

puts Device.reg.to_s

# part 2

# watch output until register 3 settles, then get the sum of its divisors.
# thats the answer.

__END__
#ip 2
addi 2 16 2
seti 1 0 4
seti 1 5 5
mulr 4 5 1
eqrr 1 3 1
addr 1 2 2
addi 2 1 2
addr 4 0 0
addi 5 1 5
gtrr 5 3 1
addr 2 1 2
seti 2 6 2
addi 4 1 4
gtrr 4 3 1
addr 1 2 2
seti 1 7 2
mulr 2 2 2
addi 3 2 3
mulr 3 3 3
mulr 2 3 3
muli 3 11 3
addi 1 6 1
mulr 1 2 1
addi 1 6 1
addr 3 1 3
addr 2 0 2
seti 0 3 2
setr 2 3 1
mulr 1 2 1
addr 2 1 1
mulr 2 1 1
muli 1 14 1
mulr 1 2 1
addr 3 1 3
seti 0 9 0
seti 0 5 2
