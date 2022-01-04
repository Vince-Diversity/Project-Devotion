extends Node2D
class_name BattleAction

signal notable_event(event_id, target)

export var true_name: String

export var use_duration := 1.0
export var needs_target := true
export var targets_allies := false
var user

func execute_action(battle, target):
	var target_state = battle.state_dict[target.name]
	if target_state.hp == 0:
		emit_signal("notable_event", "target_fainted", target)
