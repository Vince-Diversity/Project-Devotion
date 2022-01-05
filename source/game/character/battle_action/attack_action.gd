extends BattleAction
class_name AttackAction

export(float) var potency = 1

func execute_action(battle, target):
	.execute_action(battle, target)

func announce_damage(battle_ui: BattleUI, hit, target, duration = use_duration):
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
	yield(get_tree().create_timer(duration), "timeout")
