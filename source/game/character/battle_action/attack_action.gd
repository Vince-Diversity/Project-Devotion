extends BattleAction
class_name AttackAction

export(int) var potency = 1

func announce_damage(battle_ui: BattleUI, hit, target):
	if hit.is_miss:
		battle_ui.narrative.tell(
			"%s dodges the attack!" % [target.name]
		)
	elif hit.is_crit:
		battle_ui.narrative.tell(
			"A critical hit! %s lost %d hp!" % [target.name, hit.damage]
		)
	else:
		battle_ui.narrative.tell(
			"%s lost %d hp!" % [target.name, hit.damage]
		)
	yield(get_tree().create_timer(use_duration), "timeout")
