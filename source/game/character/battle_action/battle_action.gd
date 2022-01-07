extends Node2D
class_name BattleAction

signal notable_event(event_id, user, target)

export var true_name: String
export var lvl_requirement := 0
export var use_duration := 1.0
export var needs_target := true
export var targets_allies := false
export var description := "Insert description here"
var user

func execute_action(battle, target):
	var target_state = battle.state_dict[target.name]
	if target_state.hp == 0:
		emit_signal("notable_event", "target_fainted", user, target)

func change_stat(state, stat_name, multiplier):
	state[stat_name] *= multiplier
