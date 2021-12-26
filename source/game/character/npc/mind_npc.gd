extends Mind
class_name MindNPC

const decision_time = 2.0

func decide_action(battle_ui, user):
	.decide_action(battle_ui, user)
	# default action is first skill
	return user.aspect_skills.get_children()[0]

func decide_target(rng: RandomNumberGenerator, battle_ui, action: BattleAction,
					foes: Array, allies: Array):
	.decide_target(rng, battle_ui, action, foes, allies)
	# default target is random
	var target
	var role = foes
	if action.targets_allies:
		role = allies
	target = role[rng.randi() % role.size()]
	return target
