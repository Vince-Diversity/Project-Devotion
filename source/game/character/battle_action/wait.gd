extends BattleAction

func execute_action(battle, target):
	# Do absolutely nothing
	battle.battle_ui.narrative.tell(
		"%s delays their move." % [user.name]
	)
	yield(get_tree().create_timer(use_duration), "timeout")
	.execute_action(battle, target)
	return true
