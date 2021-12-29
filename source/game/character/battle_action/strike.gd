extends BattleAction

func execute_action(battle, target):
	var attack_damage: int
# warning-ignore:narrowing_conversion
	attack_damage = max(1, user.aspect.pwr / hp_pwr_ratio)
	var hit = Hit.new(attack_damage)
	battle.state_dict[target.name][battle.States.ASPECT].change_hp(hit)
	battle.battle_ui.narrative.tell(
		"%s lost %d hp!" % [target.name, attack_damage]
	)
	yield(get_tree().create_timer(use_duration), "timeout")
	.execute_action(battle, target)
	return true
