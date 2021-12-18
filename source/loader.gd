extends Node

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
var save_dir: String
var main_menu: MainMenu
var game: Game
onready var main_menu_scene := preload("res://source/main_menu/main_menu.tscn")
onready var game_scene := preload("res://source/game/game.tscn")

var save_names = {
	Kw.Aspect.SPACE: "save_%s.tres" % Kw.aspect_descr[Kw.Aspect.SPACE],
	Kw.Aspect.ENERGY: "save_%s.tres" % Kw.aspect_descr[Kw.Aspect.ENERGY],
	Kw.Aspect.MATTER: "save_%s.tres" % Kw.aspect_descr[Kw.Aspect.MATTER],
	Kw.Aspect.TIME: "save_%s.tres" % Kw.aspect_descr[Kw.Aspect.TIME],
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
		if !node.has_method("load_save"):
			print("loadable node '%s' is missing a load_save() function, skipped" % node.name)
			return
		node.call("load_save", save_game)

func _on_MainMenu_enter_dev_mode(save_id: int):
	save_dir = dev_mode_save_dir
	_enter_game(save_id)

func _on_MainMenu_enter_game(save_id: int):
	save_dir = game_save_dir
	_enter_game(save_id)

func _enter_game(save_id: int):
	game = game_scene.instance()
	game.save_dir = save_dir
	game.save_name = save_names[save_id]
	add_child(game)
	load_game(save_id)
	main_menu.queue_free()
