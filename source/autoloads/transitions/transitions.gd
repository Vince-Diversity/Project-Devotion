extends CanvasLayer

signal transition_done

const faded_color = Color.black
const default_duration = 0.5
onready var tween = $TransitionTween
onready var overcast = $Overcast

func fade(color, duration):
	tween.interpolate_property(overcast, "color",
		overcast.color, color, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func fade_out(duration = default_duration):
	fade(faded_color, duration)

func fade_in(duration = default_duration):
	overcast.color = faded_color
	fade(Color.transparent, duration)

func _on_TransitionTween_tween_all_completed():
	emit_signal("transition_done")
