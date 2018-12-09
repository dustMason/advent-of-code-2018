# part 1
# 427 players; last marble is worth 70723 points

circle = []
players = [0] * 427
current_index = 0

0.step(to: 70723) do |current|
  if current % 23 == 0 && current > 0
    players[current % players.size] += current
    current_index = (current_index - 7) % circle.size
    players[current % players.size] += circle.slice!(current_index)
  else
    current_index = (current_index + 2) % circle.size rescue 0
    circle.insert(current_index, current)
  end
end

puts players.sort.last

# part 2
# 427 players; last marble is worth 7072300 points

Marble = Struct.new(:value, :prev, :next)

current = Marble.new(0)
current.prev = current.next = current
elves = 427
players = [0] * elves

0.step(to: 7072300) do |value|
  if value % 23 == 0
    players[value % elves] += value
    current = current.prev.prev.prev.prev.prev.prev.prev
    current.prev.next = current.next
    current.next.prev = current.prev
    players[value % elves] += current.value
    current = current.next
  else
    current = current.next
    left = current
    current = current.next
    right = current
    new_marble = Marble.new(value)

    left.next = new_marble
    new_marble.prev = left
    right.prev = new_marble
    new_marble.next = right
    current = new_marble
  end
end

puts players.sort.last
