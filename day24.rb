require 'set'

input = DATA.read

IMMUNE = :immune_system
INFECTION = :infection

Group = Struct.new(
    :units,
    :hp,
    :damage,
    :initiative,
    :damage_type,
    :immunity,
    :weakness,
    :team,
    :group_number,
    :boost
) do
  def effective_power
    units * (damage + boost)
  end

  def potential_damage(power, type)
    return 0 if immunity&.include?(type)
    return power * 2 if weakness&.include?(type)
    return power
  end

  # returns boolean indicating whether or not group is still alive
  def take_hit(power, type)
    amount = potential_damage(power, type)
    units_killed = [amount / hp, units].min
    self.units -= units_killed
    self.units > 0
  end

  def enemy_team
    self.team == IMMUNE ? INFECTION : IMMUNE
  end
end

original_groups = input.split("\n\n").flat_map.with_index do |text, i|
  text.strip.lines[1..-1].map.with_index do |line, no|
    group = Group.new(*line.scan(/\d+/).map(&:to_i))
    group.damage_type = line.match(/(\w+) damage/)[1]
    notes = line.match(/\((.*)\)/)
    if notes
      notes[1].split(';').each do |note|
        note.strip!
        if note.start_with?('immune to')
          group.immunity = note.gsub(',', '').split(' ')[2..-1]
        elsif note.start_with?('weak to')
          group.weakness = note.gsub(',', '').split(' ')[2..-1]
        end
      end
    end
    group.team = [IMMUNE, INFECTION][i]
    group.group_number = no + 1
    group
  end
end

best_boost = (0..100_000).bsearch do |boost|
  groups = original_groups.map do |group|
    g = group.dup
    g.boost = g.team == IMMUNE ? boost : 0
    g
  end

  its = 0

  winner = loop do
    # 1. target selection

    matchups = []
    targets = groups.group_by(&:team)
    ranked = groups.sort_by { |g| [g.effective_power, g.initiative] }

    until ranked.empty?
      group = ranked.pop
      next if targets[group.enemy_team].empty?
      can_damage = false

      target = targets[group.enemy_team].max_by do |t|
        damage = t.potential_damage(group.damage, group.damage_type)
        can_damage = can_damage || damage > 0
        [damage, t.effective_power, t.initiative]
      end
      next unless can_damage
      matchups << [group, target]
      targets[group.enemy_team] -= [target]
    end

    # 2. attacking

    attackers = matchups.sort_by { |attacker, _defender| attacker.initiative }
    until attackers.empty?
      attacker, defender = attackers.pop
      alive = defender.take_hit(attacker.effective_power, attacker.damage_type)
      groups -= [defender] unless alive
    end

    break groups.first.team if groups.map(&:team).uniq.size < 2
    its += 1

    # some situations go way too long, so we can guess the winner by who has most
    # units left after 50k iterations.
    if its > 50_000
      break groups
                .group_by { |g| g.team }
                .max_by { |_team, groups| groups.reduce(0) { |acc, g| acc + g.units } }
                .first
    end
  end

  puts "boost #{boost}: #{groups.reduce(0) { |acc, g| acc + g.units }} #{winner} units remaining after #{its} iterations"

  winner == IMMUNE
end

puts "the best boost is #{best_boost}"

__END__
Immune System:
1432 units each with 7061 hit points (immune to cold; weak to bludgeoning) with an attack that does 41 slashing damage at initiative 17
3387 units each with 9488 hit points (weak to bludgeoning) with an attack that does 27 slashing damage at initiative 20
254 units each with 3249 hit points (immune to fire) with an attack that does 89 cold damage at initiative 1
1950 units each with 8201 hit points with an attack that does 39 fire damage at initiative 15
8137 units each with 3973 hit points (weak to slashing; immune to radiation) with an attack that does 4 radiation damage at initiative 6
4519 units each with 7585 hit points (weak to fire) with an attack that does 15 radiation damage at initiative 8
763 units each with 7834 hit points (immune to radiation, slashing, cold; weak to fire) with an attack that does 91 radiation damage at initiative 18
935 units each with 10231 hit points (immune to slashing, cold) with an attack that does 103 bludgeoning damage at initiative 12
4557 units each with 7860 hit points (immune to slashing) with an attack that does 15 slashing damage at initiative 11
510 units each with 7363 hit points (weak to fire, radiation) with an attack that does 143 fire damage at initiative 5

Infection:
290 units each with 29776 hit points (weak to cold, radiation) with an attack that does 204 bludgeoning damage at initiative 16
7268 units each with 14114 hit points (immune to radiation; weak to bludgeoning) with an attack that does 3 bludgeoning damage at initiative 19
801 units each with 5393 hit points with an attack that does 13 slashing damage at initiative 13
700 units each with 12182 hit points with an attack that does 29 cold damage at initiative 4
531 units each with 16607 hit points (immune to slashing) with an attack that does 53 bludgeoning damage at initiative 10
23 units each with 24482 hit points (weak to cold, fire) with an attack that does 2095 bludgeoning damage at initiative 7
8025 units each with 43789 hit points (weak to cold; immune to radiation) with an attack that does 8 radiation damage at initiative 9
1405 units each with 53896 hit points with an attack that does 70 slashing damage at initiative 14
566 units each with 7820 hit points (immune to cold) with an attack that does 26 cold damage at initiative 2
1641 units each with 7807 hit points (weak to fire; immune to slashing, bludgeoning) with an attack that does 7 radiation damage at initiative 3
