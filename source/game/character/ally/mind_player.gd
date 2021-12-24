extends Mind

func decide_action(battle, character):
	battle.request_battle_action(character)
	return yield(battle, "action_given")

func decide_target(rng: RandomNumberGenerator, battle, action: BattleAction, foes: Array, allies: Array) -> Array:
	battle.request_battle_target(action, foes, allies)
	return yield(battle, "target_given")
