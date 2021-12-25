extends BattleAction

func execute_action(battle, target):
	.execute_action(battle, target)
	var attack_damage: int
	attack_damage = max(1, user.aspect.pwr / hp_pwr_ratio)
	var hit = Hit.new(attack_damage)
	battle.state_dict[target.name][battle.States.ASPECT].take_damage(hit)
	battle.battle_ui.narrative.tell(
		"%s lost %d hp!" % [target.name, attack_damage]
	)
	yield(get_tree().create_timer(use_duration), "timeout")
	return true
