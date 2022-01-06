extends Object
class_name DerivedStats

const hit_deviation := 3
const crit_deviation := 3
var state: Aspect

func _init(current_state: Aspect):
	state = current_state

func get_dodge_rate() -> float:
	var target_rel_spd := get_rel_spd()
	return target_rel_spd / hit_deviation

func get_crit_rate():
	var user_rel_spd := get_rel_spd()
	return user_rel_spd / crit_deviation

func get_rel_spd() -> float:
	return max(0.0, (float(state.spd) - Aspect.BASE) / Aspect.BASE)
