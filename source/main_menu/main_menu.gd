extends Control

onready var game_scene = preload("res://source/game/game.tscn")

func _ready():
	load_game()

func load_game():
	get_tree().change_scene_to(game_scene)
