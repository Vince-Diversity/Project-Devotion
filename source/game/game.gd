extends Node2D
class_name Game

const place_data_key := "place"
const party_data_key := "party"
const opponents_data_key := "opponents"
const position_data_key := "position"
var save_dir: String
var save_name: String
var current_overworld: GameWorld
var current_battle: BattleMode
var party_dict := {"node": [], "position": [], "direction": []}
var opponents_dict := {"node": [], "position": [], "direction": []}
var opponents_party: Party
onready var SAVE_KEY := name
onready var save_path := save_dir.plus_file(save_name)
onready var ally_scene := preload("res://source/game/character/ally/ally.tscn")
onready var npc_scene := preload("res://source/game/character/npc/npc.tscn")
onready var party_scene = preload("res://source/game/world/party.tscn")

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
		place_data_key: current_overworld.filename,
		party_data_key: make_party_save_entry(party_dict),
		position_data_key: current_overworld.allies.get_leader().global_position,
	}
	if opponents_party != null:
		save_game.data[SAVE_KEY][opponents_data_key] = make_party_save_entry(opponents_dict)

func make_party_save_entry(dict):
	var ch_dict := {}
	for ch in dict["node"]:
		var content := {}
		content["aspect"] = ch.aspect
		content["level"] = ch.lvl
		content["party_order"] = ch.party_order
		content["battle_order"] = ch.battle_order
		content["visuals"] = {
			"hair": ch.hair.frames,
			"skin": ch.skin.frames,
			"body": ch.body.frames,
			"accessories": ch.accessories.frames
		}
		content["position"] = ch.global_position
		content["direction"] = ch.snapped_direction
		ch_dict[ch.name] = content
	return ch_dict

func load_save(save_game: Resource):
	var save_data = save_game.data[SAVE_KEY]
	load_place(save_data)
	load_party(party_data_key, save_data, ally_scene,
		current_overworld.allies, party_dict)
	if save_data.has(opponents_data_key):
		opponents_party = party_scene.instance()
		current_overworld.npcs.add_child(opponents_party)
		load_party(opponents_data_key, save_data, npc_scene,
			opponents_party, opponents_dict)

func load_place(save_data: Dictionary):
	var overworld_path = save_data[place_data_key]
	var place_scene = load(overworld_path)
	load_scene(place_scene)

func load_scene(place_scene: PackedScene):
	current_overworld = place_scene.instance()
	add_child(current_overworld)

func load_party(data_key, save_data: Dictionary, ch_scene, ch_party, ch_party_dict):
	var ch_dict = save_data[data_key]
	var content
	var visuals
	var ch_names = ch_dict.keys()
	var characters := Utils.Array(ch_names.size())
	var ch
	for ch_name in ch_names:
		content = ch_dict[ch_name]
		ch = ch_scene.instance()
		ch.name = ch_name
		ch.aspect = content["aspect"]
		ch.lvl = content["level"]
		ch.party_order = content["party_order"]
		ch.battle_order = content["battle_order"]
		characters[ch.party_order] = ch
	characters.invert()
	for allyo in characters:
		content = ch_dict[allyo.name]
		ch_party_dict["node"].append(allyo)
		ch_party.add_child(allyo)
#		allyo.global_position = ch_party.global_position
		ch_party_dict["position"].append(content["position"])
		ch_party_dict["direction"].append(content["direction"])
		content = ch_dict[allyo.name]
		visuals = content["visuals"]
		allyo.accessories.frames = visuals["accessories"]
		allyo.hair.frames = visuals["hair"]
		allyo.skin.frames = visuals["skin"]
		allyo.body.frames = visuals["body"]
	ch_party.assign_members()
#	ch_party.global_position = save_data[position_data_key]
	_restore_party(ch_party_dict)

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
	Transitions.fade_out()
	yield(Transitions, "transition_done")
	_store_party_props(party_dict)
	opponents_party = foe_party
	opponents_dict["node"] = foe_party.get_party_ordered()
	_store_party_props(opponents_dict)
	var battle_mode = battle_scene.instance()
	battle_mode.npc_party = foe_party
	add_child(battle_mode)
	_load_battle_helper(current_overworld.allies, battle_mode.allies)
	_load_battle_helper(foe_party, battle_mode.opponents)
	remove_child(current_overworld)
	current_battle = battle_mode
	current_battle.commence_battle()
	Transitions.fade_in()
	yield(Transitions, "transition_done")

func _store_party_props(ch_dict):
	ch_dict["position"] = []
	ch_dict["direction"] = []
	for ch in ch_dict["node"]:
		ch_dict["position"].append(ch.get_global_position())
		ch_dict["direction"].append(ch.snapped_direction)

func _load_battle_helper(our_party: Party, battle_role):
	our_party.set_state(Kw.OwStates.BATTLING)
	var party_list = our_party.get_party_ordered()
	var pos_list = battle_role.get_children()
	for i in party_list.size():
		party_list[i].prepare_battle()
	for i in party_list.size():
		our_party.remove_child(party_list[i])
		battle_role.get_node(pos_list[i].name).add_child(party_list[i])

func _on_Battle_load_overworld(foe_party, next_overworld_path):
	current_battle.remove_all_battlers()
	current_battle.queue_free()
	if next_overworld_path.empty():
		add_child(current_overworld)
	else:
		current_overworld.npcs.remove_child(foe_party)
		current_overworld = load(next_overworld_path).instance()
		add_child(current_overworld)
		current_overworld.npcs.add_child(foe_party)
	for ch in party_dict["node"]:
		current_overworld.allies.add_child(ch)
	_restore_party(party_dict)
	for ch in opponents_dict["node"]:
		foe_party.add_child(ch)
		ch.interaction_dialog = ""
	_restore_party(opponents_dict)
	_after_battle_preps(current_overworld, foe_party)

func _restore_party(dict):
	var ch
	for i in dict["node"].size():
		ch = dict["node"][i]
		ch.set_global_position(dict["position"][i])
		ch.turn_to_direction(dict["direction"][i])

func _after_battle_preps(place, foe_party):
	var leader = place.allies.get_leader()
	place.allies.set_cam_to(leader)
	place.allies.assign_members()
	place.allies.set_state(Kw.OwStates.ROAMING)
	place.after_battle_interaction(leader, foe_party)
