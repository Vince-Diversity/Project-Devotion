extends Object
class_name Hit

const hp_pwr_ratio := 5
const hit_deviation := 3
const crit_expectancy := 1.5
const crit_deviation := 4
var damage: float
var is_miss := false
var is_crit := false

func _init(rng: RandomNumberGenerator, potency: int, user_state: Aspect, target_state: Aspect):
	var target_rel_spd := get_rel_spd(target_state)
	var dodge_rate := target_rel_spd / hit_deviation
	if dodge_rate > rng.randf():
		is_miss = true
		damage = 0.0
	else:
		var attack_damage := float(user_state.pwr) / float(hp_pwr_ratio)
		attack_damage = max(0.0, float(potency) * attack_damage)
		var user_rel_spd := get_rel_spd(user_state)
		var crit_rate := user_rel_spd / crit_deviation
		if crit_rate > rng.randf():
			is_crit = true
			attack_damage *= 1 + (crit_expectancy - 1) * crit_deviation
		damage = attack_damage

func get_rel_spd(state) -> float:
	return max(0.0, (state.spd - Aspect.BASE) / Aspect.BASE)
