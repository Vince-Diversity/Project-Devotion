extends Control

signal action_given(action)
signal target_given(target)

onready var battle_option_scene = preload("res://source/game/world/battle/option_list/battle_options.tscn")
onready var target_selection_scene = preload("res://source/game/world/battle/option_list/target_selection.tscn")

func request_battle_action(character):
	var option_list = battle_option_scene.instance()
	add_child(option_list)
	option_list.character = character
	var action = yield(option_list, "action_decided")
	emit_signal("action_given", action)

func request_battle_target(action: BattleAction, foes: Array, allies: Array):
	var target_list = target_selection_scene.instance()
	add_child(target_list)
	var target = yield(target_list, "target_decided")
	emit_signal("target_given", target)
