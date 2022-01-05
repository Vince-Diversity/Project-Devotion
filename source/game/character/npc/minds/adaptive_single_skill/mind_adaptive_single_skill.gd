extends MindSingleSkill

export(String) var default_skill_name := "Strike"

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	return yield(_decide_action_helper(preferred_skill_name, battle, user, foes, allies), "completed")

func _decide_action_helper(skill: String, battle, user, foes: Array, allies: Array):
	var action = get_skill(skill)
	var target
	if action.targets_allies:
		target = decide_ally_target(action, battle, allies)
		var eval = EvaluateDecision.new(action, user, target, battle)
		if not eval.allowed:
			return _decide_action_helper(default_skill_name, battle, user, foes, allies)
	else:
		target = decide_foe_target(action, battle, foes)
	yield(get_tree().create_timer(decision_time), "timeout")
	return BattleDecision.new(action, target)
