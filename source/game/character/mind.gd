extends Node2D
class_name Mind

var character

func decide_action(_option_ui, user):
	# default action is first skill
	return user.aspect_skills.get_children()[0]

func decide_targets(rng: RandomNumberGenerator, _option_ui, _action: BattleAction, foes: Array, _allies: Array):
	# default target is random
	return foes[rng.randi() % foes.size()]
