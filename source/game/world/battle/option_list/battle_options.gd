extends OptionList

enum Options {SKILLS, STATS, WAIT}
const item_dict = {
	Options.SKILLS: "Skills",
	Options.STATS: "Stats",
	Options.WAIT: "Wait",
}
var item_names: Array
onready var skill_selection_scene = preload("res://source/game/world/battle/option_list/skill_selection.tscn")
onready var stats_selection_scene = preload("res://source/game/world/battle/option_list/stats_selection.tscn")

func _ready():
	ready_item_list()
	ready_items()

func ready_item_list():
	var item_index
	for opt in Options:
		item_index = Options[opt]
		item_names.append(item_dict[item_index])

func ready_items():
	for n in item_names:
		add_item(n)

func _on_OptionList_item_activated(index: int):
	._on_OptionList_item_activated(index)
	match index:
		Options.SKILLS:
			var skill_selection = skill_selection_scene.instance()
			_propagate_props(skill_selection)
			skill_selection.aspect_skills = character.aspect_skills
			get_parent().add_child(skill_selection)
		Options.STATS:
			var stats_selection = stats_selection_scene.instance()
			_propagate_props(stats_selection)
			stats_selection.battlers = battlers
			get_parent().add_child(stats_selection)
		Options.WAIT:
			emit_signal("action_decided", character.wait_action)
	queue_free()

func _propagate_props(inst):
	inst.character = character
	inst.option_ui = option_ui
