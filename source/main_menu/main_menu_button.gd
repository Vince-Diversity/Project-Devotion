extends TextureButton

export(String) var text
onready var label = $PointerMargin/LabelMargin/Label
onready var focus = $PointerMargin/Pointer
onready var pointer = $PointerMargin/Pointer

func _ready():
	ready_text()
	hide_focus_visual()
	set_focus_mode(true)

func ready_text():
	label.text = text

func show_focus_visual():
	focus.visible = true

func hide_focus_visual():
	focus.visible = false

func _on_MainMenuButton_focus_entered():
	show_focus_visual()

func _on_MainMenuButton_focus_exited():
	hide_focus_visual()
