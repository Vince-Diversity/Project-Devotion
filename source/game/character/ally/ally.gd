extends Character
class_name Ally

var dormant_skills := {}
onready var leader_cam = $LeaderCam
onready var wait_action = $BattleActions/Wait

func _ready():
	ready_skill_learning()
	if is_leader():
		collision_box.set_disabled(false)
		leader_cam.current = true

func ready_skill_learning():
	for skill in aspect_skills.get_children():
		skill.user = self
		if lvl < skill.lvl_requirement:
			aspect_skills.remove_child(skill)
			dormant_skills[skill.lvl_requirement] = skill

func set_lvl(new_lvl):
	.set_lvl(new_lvl)
	if dormant_skills.has(new_lvl):
		var new_skill = dormant_skills[new_lvl]
		aspect_skills.add_child(new_skill)
		return new_skill
	else: return null

func input_direction():
	.input_direction()
	inputted_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
