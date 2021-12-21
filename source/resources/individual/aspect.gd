extends Resource
class_name Aspect

export var name: String
export var spd: int
export var pwr: int
export var hp: int
export var skill_path: String

func get_stats():
	return [hp, pwr, spd]
