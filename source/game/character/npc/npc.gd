extends Character
class_name NPC

export(String, "TimelineDropdown") var interaction_dialog: String
export(String, "TimelineDropdown") var after_battle_dialog: String
export(String) var battle_path

func _ready():
	snapped_direction = get_direction(default_anim_name)

func confirm_battle():
	Events.emit_signal("load_battle", load(battle_path), party)
