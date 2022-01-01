extends MindNPC

export var fixated_aspect: Resource
export var fixated_at_allies: bool

func decide_action(battle, character):
	yield(get_tree(), "idle_frame")
	return .decide_action(battle, character)

func decide_target(battle, action: BattleAction,
					foes: Array, allies: Array):
	var target = .decide_target(battle, action, foes, allies)
	battle.battle_ui.narrative.tell(
		"%s improvises %s on %s!" % [action.user.name, action.true_name, target.name]
		)
	yield(get_tree().create_timer(decision_time), "timeout")
	return target
