extends AttackAction

func execute_action(battle, target):
	var user_state = battle.state_dict[user.name]
	var target_state = battle.state_dict[target.name]
	var hit = Hit.new(battle.rng, potency, user_state, target_state)
	battle.state_dict[target.name].change_hp(hit.damage)
	yield(announce_damage(battle.battle_ui, hit, target), "completed")
	.execute_action(battle, target)
	return true
