extends Control
class_name MainMenu

signal enter_game(save_id)

onready var game_scene := preload("res://source/game/game.tscn")
onready var focus := $Options/LoadDevMode

func _ready():
	init_options()

func init_options():
	focus.grab_focus()

func _on_LoadDevMode_pressed():
	emit_signal("enter_game", Keywords.Aspect.TIME)

func _on_LoadGame_pressed():
	print("no game to load...")
