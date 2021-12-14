extends Node2D
class_name Game

var save_path: String
#var save_path := "user://savegame_temporal.save"
#onready var place_scene: PackedScene = preload("res://source/game/world/cirruseng/cirruseng.tscn")
var place: Overworld

func _ready():
	Events.connect("save_game", self, "_on_World_save")
#	pass
#	load_world()

#func load_world():
#	place = place_scene.instance()
#	place.connect("save_game", self, "_on_World_save")
#	add_child(place)

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
