extends Node2D
class_name Game

const place_data_key := "place"
const party_data_key := "party"
var save_dir: String
var save_name: String
var overworld_path: String
var place: GameWorld
var party_dict := {"node": [], "position": [], "direction": []}
onready var SAVE_KEY := name
onready var save_path := save_dir.plus_file(save_name)
onready var ally_scene := preload("res://source/game/character/ally/ally.tscn")
onready var npc_scene := preload("res://source/game/character/npc/npc.tscn")

func _ready():
	ready_saver()

func ready_saver():
	var err
	err = Events.connect("save_game", self, "_on_Events_save_game")
	if err != OK: print("Error %s when connecting saver" % err)
	err = Events.connect("load_battle", self, "_on_NPC_load_battle")
	if err != OK: print("Error %s when connecting battle commencer")
	err = Events.connect("load_overworld", self, "_on_Battle_load_overworld")
	if err != OK: print("Error %s when connecting battle ender")

func save(save_game: Resource):
	save_game.data[SAVE_KEY] = {
		place_data_key: overworld_path,
		party_data_key: make_party_save_entry()
	}

func make_party_save_entry():
	var ally_dict := {}
	var content := {}
	for ally in party_dict["node"]:
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
	overworld_path = save_data[place_data_key]
	var place_scene = load(overworld_path)
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
	allies.invert()
	for allyo in allies:
		party_dict["node"].append(allyo)
		place.allies.add_child(allyo)
		content = ally_dict[allyo.name]
		visuals = content["visuals"]
		allyo.accessories.frames = visuals["accessories"]
		allyo.hair.frames = visuals["hair"]
		allyo.skin.frames = visuals["skin"]
		allyo.body.frames = visuals["body"]
	place.allies.assign_members()

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

func _on_NPC_load_battle(battle_scene: PackedScene, foe_party: Party):
	_store_party_props()
	var battle_mode = battle_scene.instance()
	add_child(battle_mode)
	_load_battle_helper(place.allies, battle_mode.allies)
	_load_battle_helper(foe_party, battle_mode.opponents)
#	place.allies.set_state(place.allies.get_leader().States.BATTLING)
#	var party_list = place.allies.get_party_ordered()
#	var ally_pos_list = battle_mode.allies.get_children()
#	for i in party_list.size():
#		party_list[i].prepare_battle()
#	for i in party_list.size():
#		place.allies.remove_child(party_list[i])
#		battle_mode.allies.get_node(ally_pos_list[i].name).add_child(party_list[i])
	place.queue_free()
	place = battle_mode
	battle_mode.commence_battle()

func _store_party_props():
	for ally in party_dict["node"]:
		party_dict["position"].append(ally.get_global_position())
		party_dict["direction"].append(ally.snapped_direction)

func _load_battle_helper(our_party: Party, battle_role):
	our_party.set_state(our_party.get_leader().States.BATTLING)
	var party_list = our_party.get_party_ordered()
	var pos_list = battle_role.get_children()
	for i in party_list.size():
		party_list[i].prepare_battle()
	for i in party_list.size():
		our_party.remove_child(party_list[i])
		battle_role.get_node(pos_list[i].name).add_child(party_list[i])

func _on_Battle_load_overworld():
	place.remove_all_allies()
	place.queue_free()
	var place_scene = load(overworld_path)
	place = place_scene.instance()
	add_child(place)
	_restore_party()
	var leader = place.allies.get_leader()
	place.allies.set_cam_to(leader)
	place.allies.assign_members()
	place.allies.set_state(leader.States.ROAMING)

func _restore_party():
	var ally
	for i in party_dict["node"].size():
		ally = party_dict["node"][i]
		place.allies.add_child(ally)
		ally.set_global_position(party_dict["position"][i])
		ally.turn_to_direction(party_dict["direction"][i])
