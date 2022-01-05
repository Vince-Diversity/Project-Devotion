extends MindNPC

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	var battle_action = .decide_action(battle, foes, allies)
	var action = battle_action.action
	var target = battle_action.target
	battle.battle_ui.narrative.tell(
		"%s improvises %s on %s!" % [action.user.name, action.true_name, target.name]
		)
	yield(get_tree().create_timer(decision_time), "timeout")
	return battle_action
