extends Object
class_name EvaluateDecision

var allowed: bool

func _init(action: BattleAction, user: Character, target: Character, battle: BattleMode):
	var target_state = battle.state_dict[target.name]
	var user_state = battle.state_dict[user.name]
	if action.name == "Share":
		# Target hp needs not be full
		allowed = target_state.hp < target.aspect.hp
		# The hp needs be distributed as equally as possible
		allowed = allowed and user_state.hp > target_state.hp
		# The healing amount needs be more than achievable damage
		var hit_share = HitShare.new(user_state, target_state, target.aspect)
		var max_potency_action = user.mind.get_last_max_potency_action()
		var max_potency = max_potency_action.potency
		var hit = Hit.new(battle.rng, max_potency_action.potency, user_state, target_state)
		allowed = allowed and hit_share.share > hit.get_min_attack_damage(max_potency, user_state)
