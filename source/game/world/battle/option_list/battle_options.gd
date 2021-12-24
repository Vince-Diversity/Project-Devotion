extends OptionList

enum Options {SKILLS, WAIT}
const item_dict = {
	Options.SKILLS: "Skills",
	Options.WAIT: "Wait",
}
var item_names: Array
var character: Character
onready var skill_selection_scene = preload("res://source/game/world/battle/option_list/skill_selection.tscn")

func _ready():
	init_battle_ui_connection()
	init_item_list()
	init_items()

func init_item_list():
	var item_index
	for opt in Options:
		item_index = Options[opt]
		item_names.append(item_dict[item_index])

func init_items():
	for n in item_names:
		add_item(n)

func _on_OptionList_item_activated(index: int):
	match index:
		Options.SKILLS:
			var skill_selection = skill_selection_scene.instance()
			skill_selection.aspect_skills = character.aspect_skills
			skill_selection.battle_ui = battle_ui
			get_parent().add_child(skill_selection)
		Options.WAIT:
			emit_signal("action_decided", character.wait_action)
	._on_OptionList_item_activated(index)
