extends MindNPC
class_name MindSingleSkill

export var preferred_skill_name: String
export(Resource) var default_fixated_aspect

func decide_action(battle, foes: Array, allies: Array) -> BattleDecision:
	var action = get_skill(preferred_skill_name)
	var target
	if action.targets_allies:
		target = decide_ally_target(action, battle, allies)
	else:
		target = decide_foe_target(action, battle, foes)
	yield(get_tree().create_timer(decision_time), "timeout")
	return BattleDecision.new(action, target)

func decide_ally_target(action, battle, allies):
	var target
	var other_allies = exclude_user_aspect(allies)
	if other_allies.empty():
		target = action.user
	else:
		target = get_first_lowest_hp(battle, other_allies)
	battle.battle_ui.narrative.tell(
		"%s is supporting %s!\n%s performs %s!"
		% [action.user.name, target.name, action.user.name, action.true_name]
		)
	return target

func decide_foe_target(action, battle, foes):
	var target
	var default_target = get_first_target_aspect(battle, default_fixated_aspect, foes)
	if default_target: target = default_target
	else: target = get_first_lowest_hp(battle, foes)
	battle.battle_ui.narrative.tell(
		"%s is taking down %s!\n%s performs %s!"
		% [action.user.name, target.name, action.user.name, action.true_name]
		)
	return target
