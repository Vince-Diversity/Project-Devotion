extends OptionList

var aspect_skills: AspectSkills
var skills: Array

func _ready():
	add_skills()
	add_item("Back")

func add_skills():
	skills = aspect_skills.get_children()
	for skill in skills:
		add_item(skill.name)

func _on_OptionList_item_selected(index):
	if index < skills.size():
		emit_signal("action_decided", skills[index])
