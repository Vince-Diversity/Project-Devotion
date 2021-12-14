extends TextureButton

export(String) var text
export(int) var focus_margin := 100
onready var label = $Label
onready var focus = $FocusVisual

func _ready():
	init_text()
	hide_focus_visual()
	set_focus_mode(true)

func init_text():
	label.bbcode_text = "[center] %s [/center]" % [text]

func show_focus_visual():
	focus.visible = true
	focus.global_position.y = rect_global_position.y +\
		focus.get_rect().size.y/4
	focus.global_position.x = rect_global_position.x +\
		(rect_size.x/2) - focus_margin

func hide_focus_visual():
	focus.visible = false

func _on_MainMenuButton_focus_entered():
	show_focus_visual()

func _on_MainMenuButton_focus_exited():
	hide_focus_visual()
