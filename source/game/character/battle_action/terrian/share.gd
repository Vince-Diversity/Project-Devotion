extends BattleAction

func execute_action(battle, target):
	var user_state = battle.state_dict[user.name]
	var target_state = battle.state_dict[target.name]
	var hit_share = HitShare.new(user_state, target_state, target.aspect)
	var share = hit_share.share
	if share == 0:
		battle.battle_ui.narrative.tell(
			"%s attempts %s on %s.\nBut %s's hp is already full!"
			% [user.name, true_name, target.name, target.name]
		)
		emit_signal("notable_event", "share_cancelled_full_hp", target)
		yield(get_tree().create_timer(2*use_duration), "timeout")
	else:
		user_state.change_hp(share)
		target_state.change_hp(-share)
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
