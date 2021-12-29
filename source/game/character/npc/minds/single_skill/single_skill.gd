extends MindNPC

export var fixated_skill_name: String

func decide_action(_battle_ui, character):
	yield(get_tree(), "idle_frame")
	var action
	for skill in character.aspect_skills.get_children():
		if skill.name == fixated_skill_name:
			action = skill
			break
	return action

func decide_target(_rng: RandomNumberGenerator, battle, action: BattleAction,
					foes: Array, allies: Array):
	var target
	if action.targets_allies:
		target = get_first_lowest_hp(battle, exclude_user(action.user, allies))
		battle.battle_ui.narrative.tell(
			"%s is supporting %s!\n%s performs %s!"
			% [action.user.name, target.name, action.user.name, action.true_name]
			)
	else:
		target = get_first_lowest_hp(battle, foes)
		battle.battle_ui.narrative.tell(
			"%s is taking down %s!\n%s performs %s!"
			% [action.user.name, target.name, action.user.name, action.true_name]
			)
	yield(get_tree().create_timer(decision_time), "timeout")
	return target
