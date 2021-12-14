extends MenuButton

signal save_game
signal show_objective

var menu_i = 0
var event_i = 1
var options = [
	["Objective", "show_objective"],
	["Save", "save_game"],
	]

func _ready():
	get_popup().connect("id_pressed", self, "_on_Menu_id_pressed")
	init_items()

func init_items():
	for id in options.size():
		get_popup().add_item(options[id][menu_i], id)

func _on_Menu_id_pressed(id):
	emit_signal(options[id][event_i])
