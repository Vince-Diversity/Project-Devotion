extends BattleAction

func execute_action(battle, target):
	var user_aspect = battle.state_dict[user.name]
	var user_hhp = user_aspect.hp / 2
	var target_aspect = battle.state_dict[target.name]
	var target_lost_hp = target.aspect.hp - target_aspect.hp
	var share = min(target_lost_hp, user_hhp)
	if share == 0:
		battle.battle_ui.narrative.tell(
			"%s attempts %s on %s.\nBut %s's hp is already full!"
			% [user.name, true_name, target.name, target.name]
		)
		emit_signal("notable_event", "share_cancelled_full_hp", target)
		yield(get_tree().create_timer(2*use_duration), "timeout")
	else:
		user_aspect.change_hp(share)
		target_aspect.change_hp(-share)
		if user.name == target.name:
			battle.battle_ui.narrative.tell(
				"%s shares %d hp with... themselves!" % [user.name, share]
			)
		else:
			battle.battle_ui.narrative.tell(
				"%s shares %d hp with %s!" % [user.name, share, target.name]
			)
		yield(get_tree().create_timer(use_duration), "timeout")
	.execute_action(battle, target)
	return true
