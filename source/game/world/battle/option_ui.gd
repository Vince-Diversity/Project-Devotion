extends Control

signal action_given(action)
signal target_given(target)

onready var battle_option_scene = preload("res://source/game/world/battle/option_list/battle_options.tscn")
onready var target_selection_scene = preload("res://source/game/world/battle/option_list/target_selection.tscn")
onready var ally_label = $AllyLabel

func request_battle_action(character):
	var battle_options = battle_option_scene.instance()
	battle_options.character = character
	battle_options.option_ui = self
	add_child(battle_options)
	ally_label.text = character.name

func _on_OptionList_action_decided(action: BattleAction):
	emit_signal("action_given", action)

func request_battle_target(action: BattleAction, targets: Array):
	var target_list = target_selection_scene.instance()
	target_list.targets = targets
	target_list.option_ui = self
	add_child(target_list)
	var target: Character = yield(target_list, "target_decided")
	emit_signal("target_given", target)
