extends Resource
class_name Aspect

signal stat_changed(stat, value)

const BASE := 100
export var name: String
export var symbol: String
export(int) var spd := BASE
export(int) var pwr := BASE
export(int) var hp := BASE
export var skill_path: String

func get_stats():
	return [hp, pwr, spd]

func change_hp(value):
	var diff = hp - value
	hp = int(clamp(diff, 0, max(hp, diff)))
	emit_signal("stat_changed", Kw.Stats.HP, hp)
