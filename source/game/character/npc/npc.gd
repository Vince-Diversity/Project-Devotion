extends Character
class_name NPC

export var battle: Resource

func confirm_battle():
	Events.emit_signal("load_battle", battle)
