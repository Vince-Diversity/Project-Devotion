extends Character
class_name NPC

export(String, "TimelineDropdown") var interaction_dialog: String
export var battle_path: String

func confirm_battle():
	Events.emit_signal("load_battle", load(battle_path), party)
