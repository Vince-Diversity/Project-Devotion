extends GameWorld
class_name BattleMode

enum Roles {FOES, ALLIES, SPECTATORS}
export(String, "TimelineDropdown") var starting_dialog: String
export(Array, Resource) var end_action_dialogs: Array
export(String) var new_overworld_path := ""
var npc_party: Party
var state_dict := {} # {name: aspect,...}
var turn_order := [null, null]
var turn := 0
var has_next_turn = true
var role_dict := {}
var display_dict := {}
var end_action_dict := {}
onready var rng := RandomNumberGenerator.new()
onready var spectators = $Spectators
onready var opponents = $Opponents
onready var allies = $Allies
onready var battle_ui = $BattleUI
onready var option_ui = $BattleUI/OptionUI
onready var left_status_display = $BattleUI/LeftContainer/LeftStatusDisplay
onready var right_status_display = $BattleUI/RightContainer/RightStatusDisplay
onready var bgm = $Bgm

func commence_battle():
	rng.randomize()
	ready_characters()
	ready_ui()
	yield(starting_talk(), "completed")
	bgm.play()
	yield(ready_turn_order(), "completed")
	ready_end_actions()
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
		state_dict[ch.name] = battle_aspect
		for sprite in ch.character_visual.get_sprites():
			sprite.set_animation(anim)
		if role_id == Roles.FOES:
			ch.character_visual.flip_sprite()
		for action in ch.get_actions():
			var err = action.connect("notable_event", self, "_on_BattleAction_notable_event")
			if err != OK:
				print("Error %s when connecting from action %s from %s" % [err, action, ch])

func ready_ui():
	battle_ui.option_ui.battle = self
	display_dict[Roles.FOES] = left_status_display
	display_dict[Roles.ALLIES] = right_status_display
	var display
	var ch_status
	var aspect
	for role_id in display_dict.keys():
		display = display_dict[role_id]
		for battler in get_characters(role_dict[role_id]):
			ch_status = display.add_character(battler)
			aspect = state_dict[battler.name]
			aspect.connect("stat_changed", ch_status, "_on_Aspect_stat_changed")
			aspect.connect("stat_changed", battle_ui.narrative, "_on_Aspect_stat_changed")

func starting_talk():
	if starting_dialog:
		yield(battle_ui.interject_dialog(starting_dialog), "completed")
	yield(get_tree(), "idle_frame")

func ready_turn_order():
	var roles = [opponents, allies]
	var ally_maxes = _ready_turn_order_helper(allies)
	var foe_maxes = _ready_turn_order_helper(opponents)
	var pref: String
	if foe_maxes["lvl"] > ally_maxes["lvl"]:
		var max_spd_ch
		var max_spd
		if foe_maxes["spd"] >= ally_maxes["spd"]:
			turn_order[0] = roles.pop_at(0)
			max_spd_ch = foe_maxes["lead_ch"]
			max_spd = foe_maxes["spd"]
			var lead = get_leader(turn_order[0])
			pref = "%s's team max lvl lets them be the quickest to act!" % lead.name
		else:
			turn_order[0] = roles.pop_at(1)
			max_spd_ch = ally_maxes["lead_ch"]
			max_spd = ally_maxes["spd"]
			pref = "%s's spd stat (%d) accelerates their team to act first!" \
				% [max_spd_ch.name, max_spd]
	else: # Otherwise, allies go first
		turn_order[0] = roles.pop_at(1)
		var lead = get_leader(turn_order[0])
		pref = "%s's team are most devoted and act first!" % lead.name
	battle_ui.narrative.tell(
		"%s Press X to commence!" % pref
	)
	turn_order[1] = roles.pop_at(0)
	yield(battle_ui, "accept_pressed")

func _ready_turn_order_helper(role):
	var max_lvl := 0
	var max_spd := 0
	var lead_ch
	for ch in get_characters(role):
		if ch.lvl > max_lvl:
			max_lvl = ch.lvl
		var ch_spd = state_dict[ch.name].spd
		if ch_spd > max_spd:
			max_spd = ch_spd
			lead_ch = ch
	return {
		"spd": max_spd,
		"lvl": max_lvl,
		"lead_ch": lead_ch}

func ready_end_actions():
	for dialog in end_action_dialogs:
		end_action_dict[dialog.event_id] = dialog

func play_turn():
	var playing_side = turn_order[turn % 2]
	var our_allies_ordered_initial = get_characters_ordered(playing_side)
	var our_allies
	var our_foes
	var act: BattleDecision
	for ch in our_allies_ordered_initial:
		our_allies = get_characters(playing_side)
		our_foes = get_characters(turn_order[(turn + 1) % 2])
		act = yield(ch.mind.decide_action(self, our_foes, our_allies), "completed")
		if act.action == null: print("Error: action missing on %s!" % ch.name)
		if act.target == null: print("Error: target missing for %s!" % ch.name)
		yield(commence_action(act.action, act.target), "completed")
		yield(battle_ui.end_action_dialog(), "completed")
		yield(check_standing(playing_side), "completed")
		if !has_next_turn:
			break
	turn += 1
	if has_next_turn:
		play_turn()

func commence_action(action, target):
	option_ui.ally_label.text = ""
	var action_executed = yield(action.execute_action(self, target), "completed")
	if !action_executed:
		print("Error, %s not executed!" % action.name)

func check_standing(playing_side):
	for role in role_dict.values():
		if !has_next_turn:
			break
		for ch in get_characters(role):
			if is_fallen(ch):
				fall(ch)
				battle_ui.narrative.tell(
					"%s has shattered!" % [ch.name]
				)
				yield(get_tree().create_timer(1.0), "timeout")
			else:
				yield(get_tree(), "idle_frame")
		if role.name != spectators.name:
			if get_characters(role).empty():
				has_next_turn = false
				bgm.stop()
				var leader = get_leader(playing_side)
				battle_ui.narrative.tell(
					"%s's team wins!" % [leader.name]
				)
				yield(battle_ui, "accept_pressed")
				if playing_side == role_dict[Roles.ALLIES]:
					yield(player_victory(), "completed")
				else:
					yield(player_defeat(), "completed")
				Events.emit_signal("load_overworld", npc_party, new_overworld_path)
				has_next_turn = false
				break

func player_victory():
	for ally in get_characters(role_dict[Roles.ALLIES]):
		var new_skill = ally.set_lvl(ally.lvl + 1)
		battle_ui.narrative.tell(
			"%s levels up to lvl %d!" % [ally.name, ally.lvl]
		)
		yield(battle_ui, "accept_pressed")
		if new_skill != null:
			battle_ui.narrative.tell(
				"The skill %s awakenes within %s!" \
				% [new_skill.true_name, ally.name]
			)
			yield(battle_ui, "accept_pressed")

func player_defeat():
	battle_ui.narrative.tell(
		"The player team lost spirit from their loss and did not gain any lvl."
	)
	yield(battle_ui, "accept_pressed")

func is_fallen(character):
	var aspect = state_dict[character.name]
	return aspect.hp == 0

func fall(character):
	character.get_parent().remove_child(character)

func remove_all_battlers():
	for role in [role_dict[Roles.FOES], role_dict[Roles.ALLIES]]:
		for i_pos in role.get_children():
			for node in i_pos.get_children():
				i_pos.remove_child(node)

func get_leader(role):
	return get_characters(role)[0]

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
	characters.sort_custom(BattleSorter, "ascending_battle_order")
	return characters

func get_all_character_names() -> Array:
	var names = []
	for role in role_dict.values():
		for ch in get_characters(role):
			names.append(ch.name)
	return names

func get_battlers() -> Array:
	var battlers = []
	for role in [role_dict[Roles.FOES], role_dict[Roles.ALLIES]]:
		for ch in get_characters_ordered(role):
			battlers.append(ch)
	return battlers

class BattleSorter:
	static func ascending_battle_order(ch_a, ch_b):
		if ch_a.battle_order < ch_b.battle_order:
			return true
		return false

func _on_BattleAction_notable_event(event_id, user, target) -> bool:
	var dialog: BattleDialog
	if end_action_dict.has(event_id):
		dialog = end_action_dict[event_id]
		if _has_notable_event_conditions(dialog, user, target):
			battle_ui.next_timelines.append(dialog.timeline)
			return end_action_dict.erase(event_id)
	return false

func _has_notable_event_conditions(dialog: BattleDialog, user, target):
	if not dialog.event_user_name.empty():
		if dialog.event_user_name != user.name:
			return false
	if not dialog.event_target_name.empty():
		if dialog.event_target_name != target.name:
			return false
	var existing = get_all_character_names()
	for required in dialog.required_names:
		if not required in existing:
			return false
	return true

func _on_OptionUI_stats_requested(character):
	var state = state_dict[character.name]
	battle_ui.narrative.display_stats(character, state)
