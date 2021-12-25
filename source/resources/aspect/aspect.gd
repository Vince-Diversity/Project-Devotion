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

func take_damage(hit: Hit):
	hp = clamp(hp - hit.damage, 0, hp)
	emit_signal("stat_changed", Kw.Stats.HP, hp)
