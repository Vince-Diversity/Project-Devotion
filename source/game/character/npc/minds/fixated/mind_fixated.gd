extends MindNPC

export var fixated_aspect: Resource
export var fixated_skill_name: String

func decide_action(_battle_ui, character):
	yield(get_tree(), "idle_frame")
	var action
	for skill in character.aspect_skills.get_children():
		if skill.name == fixated_skill_name:
			action = skill
			break
	return action

func decide_target(rng: RandomNumberGenerator, battle_ui, action: BattleAction,
					foes: Array, allies: Array):
	var target
	var target_found = false	
	if action.targets_allies:
		for ally in allies:
			if ally.aspect.name == fixated_aspect.name:
				target = ally
				target_found = true
				battle_ui.narrative.tell(
					"%s is set on supporting %s!\n%s performs %s!"
					% [action.user.name, target.name, action.user.name, action.true_name]
					)
				break
	else:
		for foe in foes:
			if foe.aspect.name == fixated_aspect.name:
				target = foe
				target_found = true
				battle_ui.narrative.tell(
					"%s is set on taking down %s!\n%s performs %s!"
					% [action.user.name, target.name, action.user.name, action.true_name]
					)
				break
	if !target_found:
		target = .decide_target(rng, battle_ui, action, foes, allies)
		battle_ui.narrative.tell(
			"%s performs %s on %s!"
			% [action.user.name, action.true_name, target.name]
		)
	yield(get_tree().create_timer(decision_time), "timeout")
	return target
