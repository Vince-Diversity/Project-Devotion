extends Node

onready var main_menu_scene := preload("res://source/main_menu/main_menu.tscn")
const game_scene := preload("res://source/game/game.tscn")
var main_menu: MainMenu
var game: Game

var game_save_paths = [
	"user://savegame_"+Keywords.aspect_descr[Keywords.Aspect.SPACE]+".save",
	"user://savegame_"+Keywords.aspect_descr[Keywords.Aspect.ENERGY]+".save",
	"user://savegame_"+Keywords.aspect_descr[Keywords.Aspect.MATTER]+".save",
	"user://savegame_"+Keywords.aspect_descr[Keywords.Aspect.TIME]+".save",
	]

func _ready():
	init_main_menu()

func init_main_menu():
	main_menu = main_menu_scene.instance()
	main_menu.connect("enter_game", self, "_on_MainMenu_enter_game")
	add_child(main_menu)

func load_game(save_id: int):
	var save_path = game_save_paths[save_id]
	var save_game = File.new()
	if not save_game.file_exists(save_path):
		return
	save_game.open(save_path, File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		var node_scene = load(node_data["filename"])
		var node = node_scene.instance()
		get_node(node_data["parent"]).add_child(node)
		for i in node_data.keys():
			if i=="parent" or i=="filename":
				continue
			node.set(i, node_data[i])
	save_game.close()

func _on_MainMenu_enter_game(save_id: int):
	game = game_scene.instance()
	game.save_path = game_save_paths[save_id]
	add_child(game)
	load_game(save_id)
	main_menu.queue_free()
