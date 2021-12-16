extends Node
class_name Overworld

var ally_paths: Array
onready var allies = $Allies
onready var menu = $Menu

func _process(_delta):
	if Input.is_action_pressed("ui_menu"):
		menu.get_popup().popup()

func load_team():
	var ally_scene: PackedScene
	var ally: Ally
	for i in ally_paths:
		ally_scene = load(i)
		ally = ally_scene.instance()
		allies.add_child()
