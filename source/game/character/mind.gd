extends Node2D
class_name Mind

func decide_action(rng: RandomNumberGenerator, foes: Array, allies: Array):
	# default action is attack
	pass

func decide_target(rng: RandomNumberGenerator, action: BattleAction, foes: Array, allies: Array):
	# default target is random
	pass
