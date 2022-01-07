extends OptionList

var aspect_skills: AspectSkills
var skills: Array

func _ready():
	add_skills()
	add_item("Back")

func add_skills():
	skills = aspect_skills.get_children()
	for skill in skills:
		add_item(skill.true_name)

func _on_OptionList_item_activated(index: int):
	._on_OptionList_item_activated(index)
	var size = skills.size()
	if index < size:
		emit_signal("action_decided", skills[index])
	match index:
		size:
			option_ui.request_battle_action(character)
	queue_free()

func _on_SkillSelection_item_selected(index):
	var size = skills.size()
	if index < size:
		option_ui.emit_signal("describe_option", skills[index].description)
