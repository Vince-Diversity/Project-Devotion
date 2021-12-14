extends MenuButton

enum Options {SAVE}
var label_dict = {Options.SAVE: "Save"}

func _ready():
	get_popup().connect("id_pressed", self, "_on_Menu_id_pressed")
	init_items()

func init_items():
	for opt in Options:
		var id = Options[opt]
		get_popup().add_item(label_dict[id], id)

func _on_Menu_id_pressed(id):
	match id:
		Options.SAVE: Events.emit_signal("save_game")
