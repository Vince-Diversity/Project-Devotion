extends Resource
class_name Aspect

signal stat_changed(stat, value)

export var name: String
export var spd: int
export var pwr: int
export var hp: int
export var skill_path: String

func get_stats():
	return [hp, pwr, spd]

func change_hp(hit: Hit):
	var diff = hp - hit.damage
	hp = clamp(diff, 0, max(hp, diff))
	emit_signal("stat_changed", Kw.Stats.HP, hp)
