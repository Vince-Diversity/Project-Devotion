extends MenuButton

enum Options {SAVE, CANCEL}
var label_dict = {Options.SAVE: "Save", Options.CANCEL: "Cancel"}

func _ready():
	get_popup().popup_exclusive = true
	var err = get_popup().connect("id_pressed", self, "_on_Menu_id_pressed")
	if err != OK: print("Error %s when pressing menu button"%err)
	init_items()

func init_items():
	for opt in Options:
		var id = Options[opt]
		get_popup().add_item(label_dict[id], id)

func _on_Menu_id_pressed(id):
	match id:
		Options.SAVE: Events.emit_signal("save_game")
		Options.CANCEL: pass
