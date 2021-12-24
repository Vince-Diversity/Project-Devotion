extends Mind

export var fixated_aspect: Resource
export var fixated_at_allies: bool

func decide_action(battle, character):
	.decide_action(battle, character)
	return character.battle_attack

func decide_target(rng: RandomNumberGenerator, _battle, action: BattleAction, foes: Array, allies: Array) -> Array:
	var target
	for foe in foes: # Take first foe
		if foe.aspect.name == fixated_aspect.name:
			return [foe]
	return .decide_target(rng, action, foes, allies)
