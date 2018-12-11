serial = 7347
size = 300

grid = Hash.new(0)

1.step(to: size) do |x|
  1.step(to: size) do |y|
    id = x + 10
    power = id * y
    power += serial
    power *= id
    power = power < 100 ? 0 : power.to_s.reverse[2].to_i
    power -= 5
    grid[[x, y]] = power
  end
end

1.step(to: size) do |x|
  1.step(to: size) do |y|
    grid[[x, y]] += grid[[x - 1, y]] + grid[[x, y - 1]] - grid[[x - 1, y - 1]]
  end
end

winner = [0, 0, 0]
winner_value = 0

1.step(to: size) do |block|
  1.step(to: size - block) do |x|
    1.step(to: size - block) do |y|
      value = grid[[x + block, y + block]] - grid[[x, y + block]] - grid[[x + block, y]] + grid[[x, y]]
      if value > winner_value
        winner = [x + 1, y + 1, block]
        winner_value = value
        puts winner.to_s
      end
    end
  end
end
