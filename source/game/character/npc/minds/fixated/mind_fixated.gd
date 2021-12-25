extends MindNPC

export var fixated_aspect: Resource
export var fixated_at_allies: bool

func decide_action(battle_ui, character):
	yield(get_tree(), "idle_frame")
	return .decide_action(battle_ui, character)

func decide_target(rng: RandomNumberGenerator, battle_ui, action: BattleAction,
					foes: Array, allies: Array):
	var target
	var target_found = false
	for foe in foes: # Take first foe
		if foe.aspect.name == fixated_aspect.name:
			target = foe
			target_found = true
			if action.targets_allies:
				battle_ui.narrative.tell(
					"%s is set on supporting %s!" % [action.user.name, target.name]
					)
			else:
				battle_ui.narrative.tell(
					"%s is set on taking down %s!" % [action.user.name, target.name]
					)
			break
	if !target_found:
		target = .decide_target(rng, battle_ui, action, foes, allies)
	yield(get_tree().create_timer(decision_time), "timeout")
	return target
