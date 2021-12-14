extends Node2D

const save_path = "user://savegame"
onready var place_scene: PackedScene = preload("res://source/game/world/cirruseng/cirruseng.tscn")
var place: Overworld

func _ready():
	load_game()
	load_world()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		return
	save_game.open(save_path, File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		for i in node_data.keys():
			if i=="loader":
				continue
			place_scene = load(node_data["place"])
	save_game.close()

func load_world():
	place = place_scene.instance()
	place.connect("save_game", self, "_on_World_save")
	add_child(place)

func save():
	var save_dict = {
		"loader" : get_filename(),
		"place" : place.get_filename(),
	}
	return save_dict

func _on_World_save():
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	for node in get_tree().get_nodes_in_group("Persist"):
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
		print(save_path, " saved!")
	save_game.close()
