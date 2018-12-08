# part 1

input = DATA.each_line.map { |line| line[1..-1].scan(/[A-Z]/) }

steps = input.flatten.uniq
count = steps.size
path = ''
deps = input.dup

loop do
  step = steps.select { |t| deps.none? { |_, y| y == t } }.min
  steps.delete(step)
  path << step
  deps.reject! { |x, _| x == step }
  break if path.size == count
end

puts path

# part 2

deps = input.dup

remaining = deps.flatten.uniq

goal = remaining.size
done = ''
workers = [nil] * 5
deps = deps.dup

time = 0
loop do
  workers.each_with_index do |(task, finished_at), i|
    next unless finished_at
    next unless finished_at <= time
    done << task
    workers[i] = nil
    deps.reject! { |x, _| x == task }
  end

  workers.each.with_index do |worker, i|
    next if worker
    task = remaining.select { |t| deps.none? { |_, y| y == t } }.min
    break unless task
    finished_at = time + task.ord - 4 # 'A'.ord is 65, so task of A means + 61
    workers[i] = [task, finished_at]
    remaining.delete(task)
  end
  if done.size == goal
    puts time
    break
  end
  time += 1
end

__END__
Step B must be finished before step K can begin.
Step F must be finished before step I can begin.
Step T must be finished before step U can begin.
Step R must be finished before step Z can begin.
Step N must be finished before step S can begin.
Step X must be finished before step Y can begin.
Step I must be finished before step Y can begin.
Step K must be finished before step L can begin.
Step U must be finished before step J can begin.
Step G must be finished before step L can begin.
Step W must be finished before step A can begin.
Step H must be finished before step Q can begin.
Step M must be finished before step L can begin.
Step P must be finished before step L can begin.
Step L must be finished before step A can begin.
Step V must be finished before step Y can begin.
Step Q must be finished before step Y can begin.
Step Z must be finished before step J can begin.
Step O must be finished before step D can begin.
Step Y must be finished before step A can begin.
Step J must be finished before step E can begin.
Step A must be finished before step E can begin.
Step C must be finished before step E can begin.
Step D must be finished before step E can begin.
Step S must be finished before step E can begin.
Step B must be finished before step R can begin.
Step U must be finished before step O can begin.
Step X must be finished before step I can begin.
Step C must be finished before step S can begin.
Step O must be finished before step S can begin.
Step J must be finished before step D can begin.
Step O must be finished before step E can begin.
Step Z must be finished before step O can begin.
Step J must be finished before step C can begin.
Step P must be finished before step Y can begin.
Step X must be finished before step S can begin.
Step O must be finished before step Y can begin.
Step J must be finished before step A can begin.
Step H must be finished before step C can begin.
Step P must be finished before step D can begin.
Step Z must be finished before step S can begin.
Step T must be finished before step Z can begin.
Step Y must be finished before step C can begin.
Step X must be finished before step H can begin.
Step R must be finished before step Y can begin.
Step T must be finished before step W can begin.
Step L must be finished before step O can begin.
Step G must be finished before step Z can begin.
Step H must be finished before step P can begin.
Step I must be finished before step U can begin.
Step H must be finished before step V can begin.
Step N must be finished before step Y can begin.
Step Q must be finished before step E can begin.
Step H must be finished before step D can begin.
Step P must be finished before step O can begin.
Step T must be finished before step I can begin.
Step W must be finished before step V can begin.
Step K must be finished before step M can begin.
Step R must be finished before step W can begin.
Step B must be finished before step T can begin.
Step U must be finished before step A can begin.
Step N must be finished before step H can begin.
Step F must be finished before step U can begin.
Step Q must be finished before step O can begin.
Step Y must be finished before step S can begin.
Step V must be finished before step O can begin.
Step W must be finished before step C can begin.
Step Y must be finished before step J can begin.
Step T must be finished before step V can begin.
Step N must be finished before step D can begin.
Step U must be finished before step Q can begin.
Step A must be finished before step C can begin.
Step U must be finished before step M can begin.
Step Q must be finished before step S can begin.
Step P must be finished before step V can begin.
Step B must be finished before step Z can begin.
Step W must be finished before step Q can begin.
Step L must be finished before step S can begin.
Step I must be finished before step P can begin.
Step G must be finished before step P can begin.
Step L must be finished before step C can begin.
Step K must be finished before step A can begin.
Step D must be finished before step S can begin.
Step I must be finished before step H can begin.
Step R must be finished before step M can begin.
Step Q must be finished before step D can begin.
Step K must be finished before step O can begin.
Step I must be finished before step C can begin.
Step N must be finished before step O can begin.
Step R must be finished before step X can begin.
Step P must be finished before step C can begin.
Step B must be finished before step Y can begin.
Step G must be finished before step E can begin.
Step L must be finished before step V can begin.
Step W must be finished before step Y can begin.
Step C must be finished before step D can begin.
Step M must be finished before step J can begin.
Step F must be finished before step N can begin.
Step T must be finished before step Q can begin.
Step I must be finished before step E can begin.
Step A must be finished before step D can begin.