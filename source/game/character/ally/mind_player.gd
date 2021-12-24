extends Mind

func decide_action(battle_ui, character):
	battle_ui.request_battle_action(character)
	return yield(battle_ui, "action_given")

func decide_target(_rng: RandomNumberGenerator, battle_ui, action: BattleAction, foes: Array, allies: Array) -> Array:
	battle_ui.request_battle_target(action, foes, allies)
	return yield(battle_ui, "target_given")
