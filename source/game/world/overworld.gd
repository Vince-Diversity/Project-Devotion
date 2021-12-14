extends Node2D
class_name Overworld

signal save_game

onready var menu = $Menu

func _ready():
	init_menu()

func _process(_delta):
	if Input.is_action_pressed("ui_menu"):
		menu.get_popup().popup()

func init_menu():
	menu.connect("save_game", self, "_on_Menu_save")
	menu.connect("show_objective", self, "_on_Menu_objective")
	
func _on_Menu_save():
	emit_signal("save_game")

func _on_Menu_objective():
	print("showing objective...")
