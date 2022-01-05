extends MindNPC
class_name MindFixated

export var default_fixated_aspect: Resource
export var default_skill_name: String

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	var action = get_skill(default_skill_name)
	var target
	var target_found = false
	if action.targets_allies:
		target = get_first_target_aspect(battle, default_fixated_aspect, allies)
		if target.aspect.name == default_fixated_aspect.name:
			target_found = true
			battle.battle_ui.narrative.tell(
				"%s is set on supporting %s!\n%s performs %s!"
				% [action.user.name, target.name, action.user.name, action.true_name]
				)
	else:
		target = get_first_target_aspect(battle, default_fixated_aspect, foes)
		if target.aspect.name == default_fixated_aspect.name:
			target_found = true
			battle.battle_ui.narrative.tell(
				"%s is set on taking down %s!\n%s performs %s!"
				% [action.user.name, target.name, action.user.name, action.true_name]
				)
	if !target_found:
		target = get_first_lowest_hp(battle, foes)
		battle.battle_ui.narrative.tell(
			"%s performs %s on %s!"
			% [action.user.name, action.true_name, target.name]
		)
	yield(get_tree().create_timer(decision_time), "timeout")
	return BattleDecision.new(action, target)
