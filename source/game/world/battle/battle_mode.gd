extends GameWorld

enum States {ASPECT}
var state_dict := {} # {Individual.name: {0: Individual.aspect,...}}
var turn_order := [null, null]
var turn := 0
onready var rng := RandomNumberGenerator.new()
onready var spectators = $Spectators
onready var opponents = $Opponents
onready var allies = $Allies
onready var Options = $BattleUI/OptionList.Options

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
	var ind
	for ch in get_characters(role):
		for sprite in ch.get_sprites():
			sprite.set_animation(anim)
		ind = ch.individual
		state_dict[ind.name] = {States.ASPECT: ind.aspect.duplicate()}
		scale_stats(ind)

func init_turn_order():
	var ally_max_spd = _init_turn_order_helper(allies)
	var foe_max_spd = _init_turn_order_helper(opponents)
	var roles = [opponents, allies]
	if foe_max_spd > ally_max_spd:
		turn_order[0] = roles.pop_at(0)
	elif foe_max_spd < ally_max_spd:
		turn_order[0] = roles.pop_at(1)
	else:
		var i = rng.randi_range(0, 1)
		turn_order[0] = roles.pop_at(i)
	turn_order[1] = roles.pop_at(0)

func _init_turn_order_helper(role):
	var spd_arr := []
	for ch in get_characters(role):
		spd_arr.append(state_dict[ch.individual.name][States.ASPECT].spd)
	return Utils.array_max(spd_arr)

func scale_stats(ind: Individual):
	var state = state_dict[ind.name][States.ASPECT]
	state.spd = state.spd + ind.lvl
	state.pwr = state.pwr + ind.lvl
	state.hp = state.hp + ind.lvl

func play_turn():
	var our_allies = get_characters(turn_order[turn % 2])
	var our_foes = get_characters(turn_order[(turn + 1) % 2])
	var target
	var action
	for ch in our_allies:
		action = ch.mind.decide_action(rng, our_foes, our_allies)
		target = ch.mind.decide_target(rng, action, our_foes, our_allies)
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

func _on_ItemList_item_selected(index):
	pass # Replace with function body.
