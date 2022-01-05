extends MindFixated

export(int) var numof_default_true_turns

func decide_action(battle, foes: Array, _allies: Array) -> BattleDecision:
	var max_potency_action = get_last_max_potency_action()
	var user_state = battle.state_dict[user.name]
	var koable_targets = []
	for foe in foes:
		var foe_state = battle.state_dict[foe.name]
		var hit = Hit.new(battle.rng, max_potency_action.potency, user_state, foe_state)
		if hit.get_min_attack_damage(max_potency_action.potency, user_state) >= foe_state.hp:
			koable_targets.append(foe)
	if !koable_targets.empty():
		var min_target = get_first_target_aspect(battle, default_fixated_aspect, koable_targets)
		battle.battle_ui.narrative.tell(
			"%s goes for the finishing strike on %s!\n%s performs %s!"
			% [user.name, min_target.name, user.name, max_potency_action.true_name]
		)
		yield(get_tree().create_timer(2*decision_time), "timeout")
		return BattleDecision.new(max_potency_action, min_target)
	else:
		if battle.turn >= 2*numof_default_true_turns:
			var default_target = get_first_target_aspect(battle, default_fixated_aspect, foes)
			battle.battle_ui.narrative.tell(
				"Fully devoted to the battle, %s performs %s on %s!"
				% [user.name, default_target.name, max_potency_action.true_name]
			)
			yield(get_tree().create_timer(decision_time), "timeout")
			return BattleDecision.new(max_potency_action, default_target)
		else:
			var default_action = get_skill(default_skill_name)
			var default_target = get_first_target_aspect(battle, default_fixated_aspect, foes)
			battle.battle_ui.narrative.tell(
				"%s is preparing. \n%s performs %s on %s!"
				% [user.name, user.name, default_action.true_name, default_target.name]
			)
			yield(get_tree().create_timer(decision_time), "timeout")
			return BattleDecision.new(default_action, default_target)
