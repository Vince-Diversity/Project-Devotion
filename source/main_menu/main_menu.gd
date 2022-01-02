extends Control
class_name MainMenu

signal enter_game(save_id)
signal enter_dev_mode(save_id)

onready var game_scene := preload("res://source/game/game.tscn")
onready var focus := $Options/LoadDevMode

func _ready():
	ready_options()

func ready_options():
	focus.grab_focus()

func _on_LoadDevMode_pressed():
	emit_signal("enter_dev_mode", Kw.Aspect.TIME)

func _on_LoadGame_pressed():
	emit_signal("enter_game", Kw.Aspect.TIME)
	print("Game not ready...")
