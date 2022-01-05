extends Mind
class_name MindNPC

const decision_time = 2.0

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	.decide_action(battle, foes, allies)
	# default action is first skill
	var action = user.aspect_skills.get_children()[0]
	# default target is random
	var side
	if action.targets_allies:
		side = allies
	else:
		side = foes
	var target = get_random_target(battle, side)
	return BattleDecision.new(action, target)

func exclude_user_aspect(characters):
	var exclusive = []
	for ch in characters:
		if ch.aspect.name != user.aspect.name:
			exclusive.append(ch)
	return exclusive

func get_random_target(battle, role):
	return role[battle.rng.randi() % role.size()]

func get_skill(skill_name):
	for skill in user.aspect_skills.get_children():
		if skill.name == skill_name:
			return skill

func get_first_target_aspect(battle, required_aspect: Aspect, side: Array):
	for ch in side:
		if ch.aspect.name == required_aspect.name:
			return ch
	return get_first_lowest_hp(battle, side)

func get_target_aspects(required_aspect: Aspect, side: Array) -> Array:
	var targets = []
	for ch in side:
		if ch.aspect.name == required_aspect.name:
			targets.append(ch)
	return targets

func get_first_lowest_hp(battle, side: Array):
	var ch_min = side[0]
	var min_state = battle.state_dict[ch_min.name]
	var state
	for ch in side:
		state = battle.state_dict[ch.name]
		if state.hp < min_state.hp:
			ch_min = ch
			min_state = state
	return ch_min

func get_last_max_potency_action():
	var max_action := AttackAction.new()
	for action in user.get_actions():
		if action is AttackAction:
			if max_action.potency <= action.potency:
				max_action = action
	return max_action
