extends Mind

func decide_action(battle_ui, character):
	.decide_action(battle_ui, character)
	battle_ui.narrative.tell("%s is about to act." % character.name)
	battle_ui.request_battle_action(character)
	return yield(battle_ui, "action_given")

func decide_target(rng: RandomNumberGenerator, battle_ui, action: BattleAction,
					foes: Array, allies: Array):
	.decide_target(rng, battle_ui, action, foes, allies)
	battle_ui.request_battle_target(action, foes, allies)
	return yield(battle_ui, "target_given")
