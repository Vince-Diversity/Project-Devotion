extends Character
class_name NPC

export var battle_path: String

func confirm_battle():
	Events.emit_signal("load_battle", load(battle_path))
