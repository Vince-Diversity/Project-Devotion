extends Mind

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	.decide_action(battle, foes, allies)
	battle.option_ui.request_battle_action(user)
	var action = yield(battle.option_ui, "action_given")
	var target
	if action.needs_target:
		var target_side
		if action.targets_allies: target_side = allies
		else: target_side = foes
		battle.option_ui.request_battle_target(action, target_side)
		target = yield(battle.option_ui, "target_given")
	else: target = user
	return BattleDecision.new(action, target)
