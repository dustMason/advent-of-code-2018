require 'set'
require_relative './elfputer'

input = DATA.read
device = Device.new
device.reset(0, 0, 0, 0, 0, 0)

program = input.each_line.map do |line|
  op, *args = line.split(' ')
  op.delete!('#')
  [op, *args.map(&:to_i)]
end

ip_location = program.shift.last
line_number = device.reg[ip_location]
program_range = (0...program.size)

# part 1

while program_range.cover?(line_number)
  device.reg[ip_location] = line_number
  device.send(*program[line_number])
  line_number = device.reg[ip_location] + 1
end

puts device.reg.to_s

# part 2

# watch output until register 3 settles, then get the sum of its divisors.
# that's the answer.

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
