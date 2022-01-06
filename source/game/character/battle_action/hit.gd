extends Object
class_name Hit

const hp_pwr_ratio := 5
const crit_expectancy := 1.5
var damage: float
var is_miss := false
var is_crit := false

func _init(rng: RandomNumberGenerator, potency: float, user_state: Aspect, target_state: Aspect):
	var target_derived_stats = DerivedStats.new(target_state)
	var dodge_rate = target_derived_stats.get_dodge_rate()
	if dodge_rate > rng.randf():
		is_miss = true
		damage = 0.0
	else:
		var attack_damage := get_min_attack_damage(potency, user_state)
		var user_derived_stats = DerivedStats.new(user_state)
		var crit_rate = user_derived_stats.get_crit_rate()
		if crit_rate > rng.randf():
			is_crit = true
			attack_damage *= 1 + (crit_expectancy - 1) * DerivedStats.crit_deviation
		damage = attack_damage

func get_min_attack_damage(potency, user_state) -> float:
	return max(0.0, potency * user_state.pwr / hp_pwr_ratio)
