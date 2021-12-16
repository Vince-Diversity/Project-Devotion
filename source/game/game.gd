extends Node2D
class_name Game

const place_save_key := "place"
var save_dir: String
var save_name: String
var place_path: String
var place: Overworld
onready var SAVE_KEY := Utils.gen_save_key(self)
onready var save_path := save_dir.plus_file(save_name)

func _ready():
	init_saver()

func init_saver():
	var err = Events.connect("save_game", self, "_on_Events_save_game")
	if err != OK: print("Error %s when connecting saver" % err)

func save(save_game: SaveGame):
	save_game.data[SAVE_KEY] = {
		place_save_key : place_path,
	}

func load_save(save_game: Resource):
	var save_data = save_game.data[SAVE_KEY]
	place_path = save_data[place_save_key]
	var overworld_scene = load(place_path)
	place = overworld_scene.instance()
	add_child(place)

func _on_Events_save_game():
	var save_game = SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group("Loadable"):
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		node.call("save", save_game)
	var dir = Directory.new()
	if not dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)
	var err = ResourceSaver.save(save_path, save_game)
	if err != OK:
		print("Error %s saving to %s" % [err, save_path])
