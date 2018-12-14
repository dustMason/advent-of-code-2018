# part 1

input = 635041
board = [3, 7]
elves = [0, 1]
count = 0

until count >= input + 10
  count += board.values_at(*elves).reduce(&:+).digits.reverse.each { |d| board << d }.size
  elves.map! { |e| (e + board[e] + 1) % board.size }
end

puts board[input..input+9].join

# part 2

input = "635041"
last_6 = 'whatev'
board = [3, 7]
elves = [0, 1]

until last_6 == input
  board.values_at(*elves).reduce(&:+).digits.reverse.each do |dig|
    board << dig
    last_6 << dig.to_s
    last_6[0] = ''
    break if last_6 == input
  end
  elves.map! { |e| (e + board[e] + 1) % board.size }
end

puts board.size - 6
