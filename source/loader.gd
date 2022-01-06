extends Node

const dev_mode_save_dir := "res://dev/save/"
const game_save_dir := "user://save/"
var save_dir: String
var main_menu: MainMenu
var game: Game
onready var main_menu_scene := preload("res://source/main_menu/main_menu.tscn")
onready var game_scene := preload("res://source/game/game.tscn")
onready var first_scene_path := "res://source/game/world/cutscene/cirruseng/first_scene.tscn"
onready var save_template_path := "res://source/resources/save_template.tres"

var save_names = {
	Kw.Aspects.SPACE: "save_%s.tres" % Kw.aspect_descr[Kw.Aspects.SPACE],
	Kw.Aspects.ENERGY: "save_%s.tres" % Kw.aspect_descr[Kw.Aspects.ENERGY],
	Kw.Aspects.MATTER: "save_%s.tres" % Kw.aspect_descr[Kw.Aspects.MATTER],
	Kw.Aspects.TIME: "save_%s.tres" % Kw.aspect_descr[Kw.Aspects.TIME],
}

func _ready():
	ready_main_menu()

func ready_main_menu():
	main_menu = main_menu_scene.instance()
	var err
	err = main_menu.connect("enter_dev_mode", self, "_on_MainMenu_enter_dev_mode")
	if err != OK: print("Error %s when entering dev mode"%err)
	err = main_menu.connect("enter_game", self, "_on_MainMenu_enter_game")
	if err != OK: print("Error %s when entering game"%err)
	err = main_menu.connect("enter_new_game", self, "_on_MainMenu_enter_new_game")
	if err != OK: print("Error %s when entering game"%err)
	add_child(main_menu)
	adapt_load_button()
	main_menu.enabled(false)
	Transitions.fade_in(2.0)
	yield(Transitions, "transition_done")
	main_menu.enabled(true)

func adapt_load_button():
	for id in save_names.keys():
		if has_save(id, game_save_dir):
			return
	main_menu.remove_load_button()

func has_save(save_id: int, id_save_dir: String):
	return not get_save_path(save_id, id_save_dir).empty()

func load_game(save_id: int):
	var save_path = get_save_path(save_id, save_dir)
	if save_path:
		var save_game: Resource = load(save_path)
		_load_game_helper(save_game)
	else:
		print("Error, save file %s does not exist" % save_path)

func get_save_path(save_id: int, id_save_dir: String):
	var save_name = save_names[save_id]
	var save_path = id_save_dir.plus_file(save_name)
	var save_file = File.new()
	if not save_file.file_exists(save_path):
		return ""
	else: return save_path

func _load_game_helper(save_game: Resource):
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

func _on_MainMenu_enter_new_game(save_id: int):
	save_dir = game_save_dir
	_enter_first_scene(save_id)

func _add_game(save_id: int):
	game = game_scene.instance()
	game.save_dir = save_dir
	game.save_name = save_names[save_id]
	add_child(game)

func _enter_game(save_id: int):
	main_menu.enabled(false)
	Transitions.fade_out(2.0)
	yield(Transitions, "transition_done")
	_add_game(save_id)

	load_game(save_id)

	main_menu.queue_free()
	Transitions.fade_in()
	yield(Transitions, "transition_done")

func _enter_first_scene(save_id: int):
	main_menu.enabled(false)
	Transitions.fade_out(2.0)
	yield(Transitions, "transition_done")
	_add_game(save_id)

	game.load_scene(load(first_scene_path))

	main_menu.queue_free()
	Transitions.fade_in()
	yield(Transitions, "transition_done")

func load_first_overworld(args: Array):
	Transitions.fade_out(2.0)
	yield(Transitions, "transition_done")

	var place_path = args[0]
	var save_game = load(save_template_path)
	save_game.data[game.SAVE_KEY][game.place_data_key] = place_path
	_load_game_helper(save_game)

	Transitions.fade_in()
	yield(Transitions, "transition_done")
