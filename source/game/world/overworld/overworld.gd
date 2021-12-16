extends Node
class_name Overworld

onready var allies = $Allies
onready var menu = $Menu
onready var SAVE_KEY = "overworld_"+Keywords.SaveKey.OVERWORLD
var ally_paths: Array

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

func save(save_game: SaveGame):
	save_game.data[SAVE_KEY] = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
	}

func load(save_game: Resource):
	pass
