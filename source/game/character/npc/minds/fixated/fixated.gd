extends Mind

export var fixated_aspect: Resource
export var fixated_at_allies: bool

func decide_action(rng: RandomNumberGenerator, foes: Array, allies: Array):
	.decide_action(rng, foes, allies)

func decide_target(rng: RandomNumberGenerator, action: BattleAction, foes: Array, allies: Array):
	.decide_target(rng, action, foes, allies)
