extends Control

signal accept_pressed

var next_timelines := []
onready var option_ui = $OptionUI
onready var narrative_background = $NarrativeDisplay/NarrativeBackground
onready var narrative = $NarrativeDisplay/NarrativeBackground/NarrativeTextContainer/Narrative

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed")

func interject_dialog(timeline: String):
	narrative_background.set_visible(false)
	var d = Dialogic.start(timeline)
	add_child(d)
	var keep_talk = true
	while keep_talk:
		if yield(d, "dialogic_signal") == "done":
			keep_talk = false
	yield(self, "accept_pressed")
	narrative_background.set_visible(true)

func end_action_dialog():
	for timeline in next_timelines:
		yield(interject_dialog(timeline), "completed")
	yield(get_tree(), "idle_frame")
	next_timelines = []
