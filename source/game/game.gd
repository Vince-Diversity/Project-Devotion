extends Node2D
class_name Game

const place_data_key := "place"
const party_data_key := "party"
var save_dir: String
var save_name: String
var place_path: String
var place: GameWorld
var party := []
onready var SAVE_KEY := name
onready var save_path := save_dir.plus_file(save_name)
onready var ally_scene := preload("res://source/game/character/ally/ally.tscn")
onready var npc_scene := preload("res://source/game/character/npc/npc.tscn")

func _ready():
	init_saver()

func init_saver():
	var err
	err = Events.connect("save_game", self, "_on_Events_save_game")
	if err != OK: print("Error %s when connecting saver" % err)
	err = Events.connect("load_battle", self, "_on_NPC_load_battle")
	if err != OK: print("Error %s when connecting battle commencer")

func save(save_game: Resource):
	save_game.data[SAVE_KEY] = {
		place_data_key: place_path,
		party_data_key: make_party_save_entry()
	}

func make_party_save_entry():
	var ally_dict := {}
	var content := {}
	for ally in party:
		content["aspect"] = ally.aspect
		content["level"] = ally.lvl
		content["party_order"] = ally.party_order
		content["battle_order"] = ally.battle_order
		content["visuals"] = {
			"hair": ally.hair.frames,
			"skin": ally.skin.frames,
			"body": ally.body.frames,
			"accessories": ally.accessories.frames
		}
		ally_dict[ally.name] = content
	return ally_dict

func load_save(save_game: Resource):
	var save_data = save_game.data[SAVE_KEY]
	load_place(save_data)
	load_party(save_data)

func load_place(save_data: Dictionary):
	place_path = save_data[place_data_key]
	var place_scene = load(place_path)
	place = place_scene.instance()
	add_child(place)

func load_party(save_data: Dictionary):
	var ally_dict = save_data[party_data_key]
	var content
	var visuals
	var ally_names = ally_dict.keys()
	var allies := Utils.Array(ally_names.size())
	var ally
	for ally_name in ally_names:
		content = ally_dict[ally_name]
		ally = ally_scene.instance()
		ally.name = ally_name
		ally.aspect = content["aspect"]
		ally.lvl = content["level"]
		ally.party_order = content["party_order"]
		ally.battle_order = content["battle_order"]
		allies[ally.party_order] = ally
	for allyo in allies:
		party.append(allyo)
		place.party.add_child(allyo)
		content = ally_dict[allyo.name]
		visuals = content["visuals"]
		allyo.accessories.frames = visuals["accessories"]
		allyo.hair.frames = visuals["hair"]
		allyo.skin.frames = visuals["skin"]
		allyo.body.frames = visuals["body"]

func _on_Events_save_game():
	var save_game = SaveGame.new()
	save_game.game_version = ProjectSettings.get_setting("application/config/version")
	for node in get_tree().get_nodes_in_group("Loadable"):
		if node.filename.empty():
			print("loadable node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("loadable node '%s' is missing a save() function, skipped" % node.name)
			continue
		node.call("save", save_game)
	var dir = Directory.new()
	if not dir.dir_exists(save_dir):
		dir.make_dir_recursive(save_dir)
	var err = ResourceSaver.save(save_path, save_game)
	if err != OK:
		print("Error %s saving to %s" % [err, save_path])

func _on_NPC_load_battle(battle_scene: PackedScene):
	var battle_mode = battle_scene.instance()
	add_child(battle_mode)
	var party_list = place.party.get_children()
	var ally_pos_list = battle_mode.allies.get_children()
	for i in party_list.size():
		place.party.remove_child(party_list[i])
		battle_mode.allies.get_node(ally_pos_list[i].name).add_child(party_list[i])
	place.queue_free()
	place = battle_mode
	battle_mode.commence_battle()
