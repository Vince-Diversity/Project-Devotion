extends AttackAction

const potency_divider := 2.0

func execute_action(battle, target):
	var user_state = battle.state_dict[user.name]
	var target_state = battle.state_dict[target.name]
	var numof_hits = battle.rng.randi_range(1,3)
	var duration_per_hit = use_duration / numof_hits
	var potency_per_hit = potency / potency_divider
	var total_damage := 0
	var hit_count := 0
	for _i in range(numof_hits):
		var hit = Hit.new(battle.rng, potency_per_hit, user_state, target_state)
		total_damage += hit.damage
		if !hit.is_miss: hit_count += 1
		battle.state_dict[target.name].change_hp(hit.damage)
		yield(announce_damage(battle.battle_ui, hit, target, duration_per_hit), "completed")
	if hit_count >= 2:
		battle.battle_ui.narrative.tell(
			"%d hits. %s lost %d hp in total!"
			% [hit_count, target.name, total_damage]
		)
	if hit_count == 1:
		battle.battle_ui.narrative.tell(
			"%s's attack only struck once..."
			% [user.name]
		)
	yield(get_tree().create_timer(use_duration), "timeout")
	.execute_action(battle, target)
	return true
