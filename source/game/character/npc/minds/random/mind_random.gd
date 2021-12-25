extends MindNPC

export var fixated_aspect: Resource
export var fixated_at_allies: bool

func decide_action(battle_ui, character):
	yield(get_tree(), "idle_frame")
	return .decide_action(battle_ui, character)

func decide_target(rng: RandomNumberGenerator, battle_ui, action: BattleAction,
					foes: Array, allies: Array):
	var target = .decide_target(rng, battle_ui, action, foes, allies)
	battle_ui.narrative.tell(
		"%s improvises a %s on %s!" % [action.user.name, action.name, target.name]
		)
	yield(get_tree().create_timer(decision_time), "timeout")
	return target
