extends Button

func _process(delta):
	if has_focus():
		set_modulate(Color(1,1,1,1))
		if Input.is_action_pressed(get_meta('input_next')):
			emit_signal("button_down")
		if Input.is_action_just_released(get_meta('input_next')):
			emit_signal("button_up")
			emit_signal("pressed")
	else:
		set_modulate(Color(1,1,1,0.5))
