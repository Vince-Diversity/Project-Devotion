extends Mind
class_name MindNPC

const decision_time = 2.0

func decide_action(battle_ui, user):
	.decide_action(battle_ui, user)
	# default action is first skill
	return user.aspect_skills.get_children()[0]

func decide_target(rng: RandomNumberGenerator, battle, action: BattleAction,
					foes: Array, allies: Array):
	.decide_target(rng, battle, action, foes, allies)
	# default target is random
	var target
	var role = foes
	if action.targets_allies:
		role = allies
	target = role[rng.randi() % role.size()]
	return target

func get_first_lowest_hp(battle, side: Array):
	var ch_min = side[0]
	var min_state = battle.state_dict[ch_min.name][battle.States.ASPECT]
	var state
	for ch in side:
		state = battle.state_dict[ch.name][battle.States.ASPECT]
		if state.hp < min_state.hp:
			ch_min = ch
			min_state = state
	return ch_min

func exclude_user(user, characters):
	var exclusive = []
	for ch in characters:
		if ch.name != user.name:
			exclusive.append(ch)
	return exclusive
