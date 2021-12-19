extends Node2D
class_name Game

const place_data_key := "place"
const party_data_key := "party"
var save_dir: String
var save_name: String
var place_path: String
var place: GameWorld
var party := []
onready var SAVE_KEY := Utils.gen_save_key(self)
onready var save_path := save_dir.plus_file(save_name)
onready var ally_scene := preload("res://source/game/character/ally/ally.tscn")
onready var npc_scene := preload("res://source/game/character/npc/npc.tscn")
onready var battle_scene := load("res://source/game/world/battle/battle_mode.tscn")

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
		party_data_key: get_party_individuals()
	}

func load_save(save_game: Resource):
	var save_data = save_game.data[SAVE_KEY]
	load_allies(save_data)
	load_place(save_data)

func load_allies(save_data: Dictionary):
	var allies = save_data[party_data_key]
	var ally
	for ind in allies:
		ally = ally_scene.instance()
		ally.name = ind.name
		ally.individual = ind
		party.append(ally)

func load_place(save_data: Dictionary):
	place_path = save_data[place_data_key]
	var place_scene = load(place_path)
	place = place_scene.instance()
	place.party_arr = party
	add_child(place)

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

func _on_NPC_load_battle(battle: Resource):
	var battle_mode = battle_scene.instance()
	add_child(battle_mode)
	var party_list = place.party.get_children()
	var ally_pos_list = battle_mode.allies.get_children()
	for i in party_list.size():
		place.party.remove_child(party_list[i])
		battle_mode.allies.get_node(ally_pos_list[i].name).add_child(party_list[i])
	_load_battle_npc_helper(battle.get_opponents(), battle_mode.opponents)
	_load_battle_npc_helper(battle.spectators, battle_mode.spectators)
	battle_mode.commence_battle()
	place.queue_free()
	place = battle_mode

func _load_battle_npc_helper(battle_role, battle_mode_list):
	var npc
	var pos_list = battle_mode_list.get_children()
	for i in battle_role.size():
		npc = npc_scene.instance()
		npc.individual = battle_role[i]
		npc.name = battle_role[i].name
		battle_mode_list.get_node(pos_list[i].name).add_child(npc)

func get_party_individuals():
	var inds = []
	for ally in party:
		inds.append(ally.individual)
	return inds
