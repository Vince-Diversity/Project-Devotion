extends GameWorld
class_name BattleMode

enum Roles {FOES, ALLIES, SPECTATORS}
enum States {ASPECT}
var state_dict := {} # {name: {0: aspect,...}}
var turn_order := [null, null]
var turn := 0
var role_dict := {}
var display_dict := {}
onready var rng := RandomNumberGenerator.new()
onready var spectators = $Spectators
onready var opponents = $Opponents
onready var allies = $Allies
onready var battle_ui = $BattleUI
onready var option_ui = $BattleUI/OptionUI

func commence_battle():
	rng.randomize()
	ready_characters()
	ready_ui()
	init_turn_order()
	tell_turn_order()
	play_turn()

func ready_characters():
	_ready_character_helper(opponents, Kw.anim[Kw.Anims.TENSE], Roles.FOES)
	_ready_character_helper(allies, Kw.anim[Kw.Anims.TENSE], Roles.ALLIES)
	_ready_character_helper(spectators, Kw.anim[Kw.Anims.IDLE_DOWN], Roles.SPECTATORS)

func _ready_character_helper(role, anim, role_id):
	role_dict[role_id] = role
	var battle_aspect: Aspect
	for ch in get_characters(role):
		battle_aspect = ch.aspect.duplicate()
		state_dict[ch.name] = {States.ASPECT: battle_aspect}
		for sprite in ch.get_sprites():
			sprite.set_animation(anim)

func ready_ui():
	display_dict[Roles.FOES] = $BattleUI/LeftStatusDisplay
	display_dict[Roles.ALLIES] = $BattleUI/RightStatusDisplay
	var display
	var ch_status
	var aspect
	for role_id in display_dict.keys():
		display = display_dict[role_id]
		for battler in get_characters(role_dict[role_id]):
			ch_status = display.add_character(battler)
			aspect = state_dict[battler.name][States.ASPECT]
			aspect.connect("stat_changed", ch_status, "_on_Aspect_stat_changed")
			aspect.connect("stat_changed", battle_ui.narrative, "_on_Aspect_stat_changed")

func init_turn_order():
	var roles = [opponents, allies]
	var ally_maxes = _init_turn_order_helper(allies)
	var foe_maxes = _init_turn_order_helper(opponents)
	if foe_maxes["lvl"] > ally_maxes["lvl"]:
		if foe_maxes["spd"] >= ally_maxes["spd"]:
			turn_order[0] = roles.pop_at(0)
	else: # Otherwise, allies go first
		turn_order[0] = roles.pop_at(1)
	turn_order[1] = roles.pop_at(0)

func _init_turn_order_helper(role):
	var lvl_arr := []
	var spd_arr := []
	for ch in get_characters(role):
		lvl_arr.append(ch.lvl)
		spd_arr.append(state_dict[ch.name][States.ASPECT].spd)
	return {"spd": Utils.array_max(spd_arr), "lvl": Utils.array_max(lvl_arr)}

func tell_turn_order():
	var leader = get_characters(turn_order[0])[0].name
	battle_ui.narrative.tell("%s's team are the quickest to act!" % leader)

func play_turn():
	var our_allies = get_characters_ordered(turn_order[turn % 2])
	var our_foes = get_characters_ordered(turn_order[(turn + 1) % 2])
	var action
	var target
	for ch in our_allies:
		action = yield(ch.mind.decide_action(battle_ui, ch), "completed")
		if action == null: print("Error: action missing on %s!" % ch.name)
		if action.needs_target:
			target = yield(ch.mind.decide_target(rng, battle_ui, action, our_foes, our_allies), "completed")
			if target == null: print("Error: target missing for %s!" % ch.name)
		yield(commence_action(action, target), "completed")
	turn += 1
	play_turn()

func commence_action(action, target):
	option_ui.ally_label.text = ""
	var action_executed = yield(action.execute_action(self, target), "completed")
	if !action_executed:
		print("Error, %s not executed!" % action.name)

func get_characters(role) -> Array:
	var characters = []
	for i_pos in role.get_children():
		if i_pos.get_child_count() == 1:
			characters.append(i_pos.get_child(0))
		if i_pos.get_child_count() > 1:
			print("Error, more than one node under the Position2D")
	return characters

func get_characters_ordered(role) -> Array:
	var characters = get_characters(role)
	var size = characters.size()
	var ordered := Utils.Array(size)
	var ch
	for i in range(size):
		ch = characters[i]
		ordered[ch.battle_order] = ch
	return ordered
