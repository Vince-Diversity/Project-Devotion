extends Control
class_name MainMenu

signal enter_game(save_id)
signal enter_dev_mode(save_id)
signal enter_new_game(save_id)

onready var game_scene := preload("res://source/game/game.tscn")
onready var options := $Options
onready var load_button = $Options/LoadGame
onready var new_button = $Options/NewGame
onready var focus = load_button
onready var controls = $Controls
onready var bgm = $Bgm

func enabled(flag: bool):
	for button in options.get_children():
		button.disabled = !flag
	options.set_visible(flag)
	controls.set_visible(flag)
	if flag: bgm.play()
	else: bgm.stop()
	focus.grab_focus()

func remove_load_button():
	options.remove_child(load_button)
	focus = new_button

func _on_LoadDevMode_pressed():
	emit_signal("enter_dev_mode", Kw.Aspects.TIME)

func _on_LoadGame_pressed():
	emit_signal("enter_game", Kw.Aspects.TIME)

func _on_NewGame_pressed():
	emit_signal("enter_new_game", Kw.Aspects.TIME)

func _on_Quit_pressed():
	get_tree().quit()
