extends Node2D
class_name Game

const save_game := preload("res://source/resources/save_game.gd")
var save_path: String
var place: Overworld

func _ready():
	Events.connect("save_game", self, "_on_Events_save_game")

func _on_Events_save_game():
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)
	for node in get_tree().get_nodes_in_group("Persist"):
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save", save_game)
		save_game.store_line(to_json(node_data))
	save_game.close()
	print(save_path, " saved!")
