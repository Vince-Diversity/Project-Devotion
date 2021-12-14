extends Node2D
class_name Overworld

signal save_game

onready var menu = $Menu

func _ready():
	init_menu()

func _process(_delta):
	if Input.is_action_pressed("ui_menu"):
		menu.get_popup().popup()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
#		"parent" : "/root/Loader/Game",
	}
	return save_dict

func init_menu():
	pass
#	menu.connect("save_game", self, "_on_Menu_save")
	
#func _on_Menu_save():
#	emit_signal("save_game")
