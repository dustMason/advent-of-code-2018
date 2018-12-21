require 'set'
require_relative './elfputer'

input = DATA.read
device = Device.new

program = input.each_line.map do |line|
  next if line.strip == ''
  op, arg1, arg2, arg3, = line.split(' ')
  op.delete!('#')
  args = [arg1, arg2, arg3].compact.map(&:to_i)
  [op, *args]
end.compact

# device.reset(2159153, 0, 0, 0, 0, 0)
device.reset(0, 0, 0, 0, 0, 0)

ip_location = program.shift.last
line_number = device.reg[ip_location]
program_range = (0...program.size)

# part 1

vals = Set.new
reg1 = []
i = 0

while program_range.cover?(line_number)
  if program[line_number].first == 'eqrr'
    i += 1
    print '.'
    if !vals.include?(device.reg[1])
      reg1 << device.reg[1]
      reg1.shift if reg1.size > 2
      vals << device.reg[1]
    else
      puts "hi! #{device.reg[1]} --- #{reg1}"
      exit
    end
  end
  device.reg[ip_location] = line_number
  device.send(*program[line_number])
  line_number = device.reg[ip_location] + 1
end

puts i
puts device.reg.to_s

__END__
#ip 5
seti 123 0 1      | set reg1 to 123
bani 1 456 1      | set reg1 to 123 (reg1) & 456
eqri 1 72 1       | set reg1 to 1 if 72 == 72 (reg1)
addr 1 5 5        | set reg5 to 1 (reg1) + 0 (reg5)
seti 0 0 5        | set reg5 to 0 [GOTO 0, this is the loop]

seti 0 4 1        | set reg1 to 0 [AARDVARK]
bori 1 65536 4    | set reg4 to 0 (reg1) | 65536 = 65536

seti 12772194 7 1 | set reg1 to 12772194
bani 4 255 3      | set reg3 to 65536 (reg4) & 255 = 0
addr 1 3 1        | set reg1 to 12772194 (reg1) + 0 (reg3)
bani 1 16777215 1 | set reg1 to 12772194 (reg1) & 16777215
muli 1 65899 1    | set reg1 to 841674812406 (reg1) * 65899
bani 1 16777215 1 | set reg1 to 12217334 (reg1) & 16777215
gtir 256 4 3      | hi
addr 3 5 5        | hi
addi 5 1 5        | hi
seti 27 3 5       | set reg5 to 27 -- ends up at AARDVARK
seti 0 0 3        | set reg3 to 0
addi 3 1 2        | set reg2 to (reg3) + 1 --- top of loop
muli 2 256 2      | hi
gtrr 2 4 2        | hi
addr 2 5 5        | hi
addi 5 1 5        | hi
seti 25 5 5       | hi
addi 3 1 3        | hi
seti 17 4 5       | set reg5 to 17 --- end of loop
setr 3 4 4        | hi
seti 7 1 5        | set reg5 to 7 -- jump to AARDVARK
eqrr 1 0 3        | set reg3 to 1 if 2159153 (reg1) eq 0 (reg0)
addr 3 5 5        | set reg5 to (reg3) + (reg5)
seti 5 1 5        | loop back to top!