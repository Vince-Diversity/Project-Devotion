extends Node2D
class_name BattleAction

const hp_pwr_ratio = 5
export var use_duration := 1.0
export var needs_target := true
export var targets_allies := false
var user

func execute_action(_battle, targets):
	pass
