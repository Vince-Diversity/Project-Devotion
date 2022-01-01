extends Character
class_name Ally

onready var leader_cam = $LeaderCam
onready var wait_action = $BattleActions/Wait

func _ready():
	if is_leader():
		collision_box.set_disabled(false)
		leader_cam.current = true

func input_direction():
	.input_direction()
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
