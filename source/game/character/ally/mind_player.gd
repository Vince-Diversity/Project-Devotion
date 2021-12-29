extends Mind

func decide_action(battle_ui, character):
	.decide_action(battle_ui, character)
	battle_ui.option_ui.request_battle_action(character)
	return yield(battle_ui.option_ui, "action_given")

func decide_target(rng: RandomNumberGenerator, battle, action: BattleAction,
					foes: Array, allies: Array):
	.decide_target(rng, battle, action, foes, allies)
	var target_side
	if action.targets_allies:
		target_side = allies
	else:
		target_side = foes
	battle.option_ui.request_battle_target(action, target_side)
	return yield(battle.option_ui, "target_given")
