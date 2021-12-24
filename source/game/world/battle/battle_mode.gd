extends GameWorld
class_name BattleMode

enum States {ASPECT}
var state_dict := {} # {name: {0: aspect,...}}
var turn_order := [null, null]
var turn := 0
onready var rng := RandomNumberGenerator.new()
onready var spectators = $Spectators
onready var opponents = $Opponents
onready var allies = $Allies
onready var option_ui = $BattleUI/OptionUI

func commence_battle():
	rng.randomize()
	ready_characters()
	init_turn_order()
	play_turn()

func ready_characters():
	_ready_character_helper(opponents, Kw.anim[Kw.Anims.TENSE])
	_ready_character_helper(allies, Kw.anim[Kw.Anims.TENSE])
	_ready_character_helper(spectators, Kw.anim[Kw.Anims.IDLE_DOWN])

func _ready_character_helper(role, anim):
	for ch in get_characters(role):
		for sprite in ch.get_sprites():
			sprite.set_animation(anim)
		state_dict[ch.name] = {States.ASPECT: ch.aspect.duplicate()}

func init_turn_order():
	var ally_max_spd = _init_turn_order_helper(allies)
	var foe_max_spd = _init_turn_order_helper(opponents)
	var roles = [opponents, allies]
	# Allies go first
	turn_order[0] = roles.pop_at(1)
	turn_order[1] = roles.pop_at(0)

func _init_turn_order_helper(role):
	var spd_arr := []
	for ch in get_characters(role):
		spd_arr.append(state_dict[ch.name][States.ASPECT].spd)
	return Utils.array_max(spd_arr)

func play_turn():
	var our_allies = get_characters_ordered(turn_order[turn % 2])
	var our_foes = get_characters_ordered(turn_order[(turn + 1) % 2])
	var action
	var target
	for ch in our_allies:
		action = yield(ch.mind.decide_action(option_ui, ch), "completed")
		if action.needs_target:
			target = yield(ch.mind.decide_target(rng, option_ui, action, our_foes, our_allies), "completed")
	var action_executed = action.execute_action(self, target)
	turn += 1
	return
	play_turn()

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
