extends BattleAction

func execute_action(battle, targets):
	if not targets:
		return false
	var attack_damage: int
	attack_damage = character.aspect.pwr / hp_pwr_ratio + 1
	var hit = Hit.new(attack_damage)
	battle.state_dict[targets[0].name][battle.States.ASPECT].take_damage(hit)
	return true
