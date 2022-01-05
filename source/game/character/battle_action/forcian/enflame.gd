extends AttackAction

func execute_action(battle, target):
	var user_state = battle.state_dict[user.name]
	var target_state = battle.state_dict[target.name]
	var hit = Hit.new(battle.rng, potency, user_state, target_state)
	battle.state_dict[target.name].change_hp(hit.damage)
	yield(announce_damage(battle.battle_ui, hit, target), "completed")
	.execute_action(battle, target)
	if !hit.is_miss:
		change_stat(user_state, "pwr", 1.20)
		battle.battle_ui.narrative.tell(
			"%s accumulates heat and raises pwr by 20 %%!" % [user.name]
		)
		yield(get_tree().create_timer(use_duration), "timeout")
	return true
