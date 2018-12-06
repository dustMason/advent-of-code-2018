require 'set'
require 'json'

input = DATA.read
points = input.each_line.map { |line| line.split(', ').map(&:to_i) }

def dist(coord1, coord2)
  (coord1[0] - coord2[0]).abs + (coord1[1] - coord2[1]).abs
end

# part 1

def closest(bounds, points)
  map = Hash.new(0)

  bounds.each do |i|
    bounds.each do |j|
      current_point = [i, j]
      distances = points.map { |point| [point, dist(point, current_point)] }
                      .sort_by { |(_point, distance)| distance }
      next if distances[0][1] == distances[1][1]
      map[distances[0][0]] += 1
    end
  end

  map
end

closest1 = closest((0..350), points).sort_by { |_point, distance| distance }.reverse.to_h
closest2 = closest((-50..400), points).sort_by { |_point, distance| distance }.reverse.to_h

closest2.each do |(point2, dist2)|
  if closest1[point2] == dist2
    puts "#{point2} has #{dist2}"
    break
  end
end

# part 2

within = 0

(0..350).each do |i|
  (0..350).each do |j|
    current_point = [i, j]
    distance = points.reduce(0) { |acc, point| acc + dist(point, current_point) }
    within += 1 if distance < 10_000
  end
end

puts within

__END__
108, 324
46, 91
356, 216
209, 169
170, 331
332, 215
217, 104
75, 153
110, 207
185, 102
61, 273
233, 301
278, 151
333, 349
236, 249
93, 155
186, 321
203, 138
103, 292
47, 178
178, 212
253, 174
348, 272
83, 65
264, 227
239, 52
243, 61
290, 325
135, 96
165, 339
236, 132
84, 185
94, 248
164, 82
325, 202
345, 323
45, 42
292, 214
349, 148
80, 180
314, 335
210, 264
302, 108
235, 273
253, 170
150, 303
249, 279
255, 159
273, 356
275, 244