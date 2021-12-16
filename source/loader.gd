extends Node

const save_dir := "user://save/"
const dev_mode_save_dir := "res://debug/save/"
var main_menu: MainMenu
var game: Game
onready var main_menu_scene := preload("res://source/main_menu/main_menu.tscn")
onready var game_scene := preload("res://source/game/game.tscn")

var save_names = {
	Keywords.Aspect.SPACE: "save_%s.tres" % Keywords.aspect_descr[Keywords.Aspect.SPACE],
	Keywords.Aspect.ENERGY: "save_%s.tres" % Keywords.aspect_descr[Keywords.Aspect.ENERGY],
	Keywords.Aspect.MATTER: "save_%s.tres" % Keywords.aspect_descr[Keywords.Aspect.MATTER],
	Keywords.Aspect.TIME: "save_%s.tres" % Keywords.aspect_descr[Keywords.Aspect.TIME],
}

func _ready():
	init_main_menu()

func init_main_menu():
	main_menu = main_menu_scene.instance()
	var err
	err = main_menu.connect("enter_dev_mode", self, "_on_MainMenu_enter_dev_mode")
	if err != OK: print("Error %s when entering dev mode"%err)
	err = main_menu.connect("enter_game", self, "_on_MainMenu_enter_game")
	if err != OK: print("Error %s when entering game"%err)
	add_child(main_menu)

func load_game(save_id: int):
	var save_name = save_names[save_id]
	var save_path = save_dir.plus_file(save_name)
	var save_file = File.new()
	if not save_file.file_exists(save_path):
		print("Error, save file %s does not exist" % save_path)
		return
	var save_game: Resource = load(save_path)
	for node in get_tree().get_nodes_in_group("Loadable"):
		node.call("load_save", save_game)

func _on_MainMenu_enter_dev_mode(save_id: int):
	game = game_scene.instance()
	game.save_dir = dev_mode_save_dir
	game.save_name = save_names[save_id]
	add_child(game)
	load_game(save_id)
	main_menu.queue_free()

func _on_MainMenu_enter_game(save_id: int):
	game = game_scene.instance()
	game.save_dir = save_dir
	game.save_name = save_names[save_id]
	add_child(game)
	load_game(save_id)
	main_menu.queue_free()
